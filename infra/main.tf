terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.33.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

module "app_service_module" {
  source   = "./app_service_module"
  LOCATION = var.LOCATION
  ENV      = var.ENV
  APPNAME  = var.APPNAME
  SKU      = var.SKU
}