terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
    
  }
}

provider "azurerm" {
  subscription_id = var.azure-environment.subscription_id
  tenant_id       = var.azure-environment.tenant_id
  client_id       = var.azure-environment.client_id
  client_secret   = var.azure-environment.client_secret

  on_failure = continue
  
  features {}
}