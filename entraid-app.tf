# Azure ADアプリケーションの作成
resource "azuread_application" "entra_id_app" {
  display_name = "AppGatewayAuthApp"

  web {
    redirect_uris = [
      "https://${var.resourcegroup-name}.azurewebsites.net/auth/login/aad/callback"
    ]
  }
}

# サービスプリンシパルの作成
resource "azuread_service_principal" "entra_id_app_sp" {
  client_id = azuread_application.entra_id_app.client_id
}

# サービスプリンシパルのパスワードの作成
resource "azuread_service_principal_password" "entra_id_app_password" {
  service_principal_id = azuread_service_principal.entra_id_app_sp.id
  display_name         = "AppPassword"
  end_date = timeadd(timestamp(), "87600h") # 最長10年間の有効期限
}

