provider "azurerm" {
  features {}
}

# Define variables
variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "team4"
}

variable "location" {
  description = "Azure region location"
  default     = "East US"
}

variable "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  default     = "mysqlserverteam4"
}

variable "mysql_admin_username" {
  description = "Admin username for the MySQL Flexible Server"
  default     = "jeevana"
}

variable "mysql_admin_password" {
  description = "Admin password for the MySQL Flexible Server"
  default     = "Project123@"
}

variable "static_web_app_name" {
  description = "Name of the Static Web App"
  default     = "mywebappteam4"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (ACR)"
  default     = "myacrteam4project"
}

variable "aks_cluster_name" {
  description = "Name of the Azure Kubernetes Service (AKS) cluster"
  default     = "myaksteam4"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                = var.mysql_server_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  administrator_login = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name               = "Standard_B1s"
  create_mode         = "Default"  

  tags = {
    environment = "production"
  }
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Static Web App
resource "azurerm_static_site" "static_web_app" {
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}
