terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.70"
       }
      random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {

    subscription_id = var.subscription-id
    features {}
}

provider "azuread" {
  # 必要に応じて設定を追加
}