# FRONT-END

# Public Web App ASP
resource "azurerm_service_plan" "public_asp" {
  name                = "abc-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  os_type             = "Linux"
  depends_on = [
    azurerm_subnet.public_subnet
  ]

}

# Front-End Web App
resource "azurerm_linux_web_app" "public_webapp" {
  name                = "abc-dev-app-asr64"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  https_only          = true
  service_plan_id     = azurerm_service_plan.public_asp.id
  site_config {
    minimum_tls_version = "1.2"
  }
  depends_on = [
    azurerm_service_plan.public_asp
  ]
}

# BACK-END


# Private API ASP
resource "azurerm_service_plan" "backend_asp" {
  name                = "abc-api-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  os_type             = "Linux"
  depends_on = [
    azurerm_subnet.private_subnet,
    azurerm_storage_account.fa_storage
  ]

}
# Function App storage
resource "azurerm_storage_account" "fa_storage" {
  name                     = "fastorage78654"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}


# Linux Function APp

resource "azurerm_linux_function_app" "backend_fa" {
  name                       = "abc-fa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = azurerm_storage_account.fa_storage.name
  storage_account_access_key = azurerm_storage_account.fa_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.backend_asp.id

  site_config {
    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.public_subnet.id
      priority                  = 100
      name                      = "Public Web App"

    }

  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_storage_account.fa_storage
  ]

}

# Vnet integration with App services 
resource "azurerm_app_service_virtual_network_swift_connection" "public_vnet_integration" {
  app_service_id = azurerm_linux_web_app.public_webapp.id
  subnet_id      = azurerm_subnet.public_subnet.id
  depends_on = [
    azurerm_linux_web_app.public_webapp
  ]

}

resource "azurerm_app_service_virtual_network_swift_connection" "private_vnet_integration" {
  app_service_id = azurerm_linux_function_app.backend_fa.id
  subnet_id      = azurerm_subnet.private_subnet.id
  depends_on = [
    azurerm_linux_function_app.backend_fa
  ]

}