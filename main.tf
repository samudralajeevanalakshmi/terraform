# Define variables
variable "resource_group_name" {
  description = "Name of the resource group"
  default = "team4"
}

variable "location" {
  description = "Azure region location"
  default = "EAST US"
}

variable "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  default = "mysqlserverteam4"
}

variable "mysql_admin_username" {
  description = "Admin username for the MySQL Flexible Server"
  default = "jeevana"
}

variable "mysql_admin_password" {
  description = "Admin password for the MySQL Flexible Server"
  default = "Project123@"
}

variable "static_web_app_name" {
  description = "Name of the Static Web App"
  default = "mywebappteam4"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  administrator_login = var.mysql_admin_username
  admin_password      = var.mysql_admin_password
  sku_name            = "Standard_D2s_v3"
  charset             = "utf8mb4"

  storage {
    storage_size_gb = 20
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
