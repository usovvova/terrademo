terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 1.0"

  backend "remote" {
    organization = "Anu-demo"

    workspaces {
      name = "demo_github"
    }
  }
}
provider "azurerm" {
  features {}
 # skip_provider_registration = true
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "BatmanInc"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "1-132719e7-playground-sandbox"
}
