# Virtual Network
resource "azurerm_virtual_network" "multitier_vnet" {
  name                = "multitier-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.3.0.0/16"]
}

# Public Subnet for Fron-End WebApp
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.multitier_vnet.name
  address_prefixes     = ["10.3.0.0/26"]
  service_endpoints    = ["Microsoft.Web"]
  delegation {
    name = "appservice_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }

  }
}

# Private Subnet for backend API and DB
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.multitier_vnet.name
  address_prefixes     = ["10.3.0.64/26"]
  service_endpoints    = ["Microsoft.Sql"]
  delegation {
    name = "appservice_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}