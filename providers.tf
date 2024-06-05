provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  default = "revhireResourceGroup"
}

variable "location" {
  default = "West Europe"
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}
