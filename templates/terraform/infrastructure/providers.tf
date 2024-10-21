terraform {
  required_version = ">=1.8"
  # Populated at runtime by the pipeline by callin terraform init
  backend "azurerm" {
    resource_group_name  = "" 
    storage_account_name = ""
    container_name       = ""
    key                  = ""
  }
}

provider "azurerm" {
  features {}
}