terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.90.0"
      #version = "3.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9d4350c8-e11c-4007-a923-c1df11a52bab"
}