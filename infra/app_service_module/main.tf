resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.env}-${var.appname}-RG-${random_integer.ri.result}"
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.env}-${var.appname}-ASP-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = var.sku
}

resource "azurerm_linux_web_app" "web-app" {
  name                = "${var.env}-${var.appname}-APP-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  https_only = true

  site_config {
    minimum_tls_version = "1.2"
    always_on = azurerm_service_plan.asp.sku_name == "F1" ? false : true

    application_stack {
      dotnet_version = "6.0"
    }
  }
}