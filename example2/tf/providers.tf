terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.29.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9d4350c8-e11c-4007-a923-c1df11a52bab"
}