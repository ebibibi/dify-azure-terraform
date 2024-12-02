resource "azurerm_public_ip" "appgw_ip" {
  name                = "appgw-ip"
  resource_group_name = var.resourcegroup-name
  location            = var.region
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgateway"
  resource_group_name = var.resourcegroup-name
  location            = var.region

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ipconfig"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_ip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    require_sni                    = false
  }

  request_routing_rule {
    name                       = "route-to-backend"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-http-settings"
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  ssl_profile {
    name = "managed-ssl-profile"
    ssl_policy {
      policy_type = "Predefined"
      policy_name = "AppGwSslPolicy20170401"
    }
  }
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw_ip.ip_address
}
