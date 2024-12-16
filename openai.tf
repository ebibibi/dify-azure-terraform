module "openai_cognitive_service" {
  source              = "Azure/avm-res-cognitiveservices-account/azurerm"
  version             = "0.4.0"  # Replace with the latest version

  # Required settings
  name                = "openai-${var.resourcegroup-name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"  # Specifies the type of Cognitive Service Account
  sku_name            = "S0"      # Specifies the SKU for OpenAI

  tags = {
    environment = "production"
  }
}

# Reference the created Cognitive Services account
data "azurerm_cognitive_account" "openai_service" {
  name                = module.openai_cognitive_service.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_endpoint" "openai_private_endpoint" {
  name                = "openai-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.privatelinksubnet.id

  private_service_connection {
    name                           = "openai-connection"
    private_connection_resource_id = data.azurerm_cognitive_account.openai_service.id
    subresource_names              = ["account"]  # Confirm if "account" is the correct subresource name
    is_manual_connection           = false
  }

  depends_on = [module.openai_cognitive_service]
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "openai_dns_record" {
  name                = "openai"
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.openai_private_endpoint.private_service_connection[0].private_ip_address]
}