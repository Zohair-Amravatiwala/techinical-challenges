terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "multitier_app_rg"
    storage_account_name = "multitiertfstatesa"
    container_name       = "dev"
    key                  = "devtfstate"
    use_azuread_auth     = true

  }

}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "multitier-app-rg"
  location = "eastus"
}









