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
  location = "East US"
  env      = "DEV"
  appname  = "DOT-NET-TEST"
  sku      = "F1"
}