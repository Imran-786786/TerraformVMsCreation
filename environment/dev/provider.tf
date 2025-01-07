terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}
provider "azurerm" {
  features {

  }
  subscription_id = "dfae4920-89de-4693-a1a4-95ff4eab4809"
}
