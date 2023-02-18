resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.ENV}-${var.APPNAME}-RG-${random_integer.ri.result}"
  location = var.LOCATION
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.ENV}-${var.APPNAME}-ASP-${random_integer.ri.result}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Windows"
  sku_name = var.SKU
}

resource "azurerm_windows_web_app" "web-app" {
  name                = "${var.ENV}-${var.APPNAME}-APP-${random_integer.ri.result}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  https_only = true

  site_config {
    minimum_tls_version = "1.2"
    always_on = azurerm_service_plan.asp.sku_name == "F1" ? false : true

    application_stack {
      dotnet_version = "v7.0"
    }
  }
}

output "appname" {
  value = azurerm_windows_web_app.web-app.name
  description = "Name of deployed app"
}