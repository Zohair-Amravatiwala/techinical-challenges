output "public_WebApp_URL" {
  value = "${azurerm_linux_web_app.public_webapp.name}.azurewebsites.net"
}

output "private_backend_fa_URL" {
  value = "${azurerm_linux_function_app.backend_fa.name}.azurewebsites.net"
}