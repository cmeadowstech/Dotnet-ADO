variable "env" {
  default = "DEV"
  type    = string
}

variable "appname" {
  default = "NET-TEST"
  type    = string
}

variable "location" {
  default = "East US"
  type    = string
}

variable "sku" {
  default     = "F1"
  type        = string
  description = "Which SKU to deploy the ASP to. Choose F1 or B1"

  validation {
    condition     = contains(["F1", "B2"], var.sku)
    error_message = "Valid values for var: test_variable are (F1, B1)."
  }
}

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

    application_stack {
      dotnet_version = "6.0"
    }
  }
}