# MS SQL DB server

resource "azurerm_mssql_server" "private_server" {
  name                         = "abc-dev-svr"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "abcadministrator"
  administrator_login_password = "somesecurestring@1218as"
  minimum_tls_version          = "1.2"

}

# VNet integration with private subnet
resource "azurerm_mssql_virtual_network_rule" "vnet_svr_rule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.private_server.id
  subnet_id = azurerm_subnet.private_subnet.id

  depends_on = [
    azurerm_mssql_server.private_server
  ]
}

# SQL DB
resource "azurerm_mssql_database" "private_database" {
  name           = "abc-dev-db"
  server_id      = azurerm_mssql_server.private_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false

}