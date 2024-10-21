terraform {
  required_version = ">=1.8"

  required_providers {
    azapi = {
      source = "azure/azapi"
      version = "~>1.13"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.106"
    }
  }
}

provider "azurerm" {
  features {}
}