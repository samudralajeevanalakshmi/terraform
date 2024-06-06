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
  default     = "eastus2"
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

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
  default     = "team4-app-service-plan"
}

variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
  default     = "appservice"
}

variable "static_web_app_name" {
  description = "Name of the Static Web App"
  default     = "mywebappteam4"
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

  sku_name = "B_Standard_B1ms"  # Using Basic SKU for flexible server

  storage {
    size_gb = 20  # Minimum storage size is 20GB
  }

  version = "5.7"

  tags = {
    environment = "development"
  }
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "acrteam4"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "development"
  }
}

# Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aksteam4"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aksteam4"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "development"
  }
}

resource "azurerm_service_plan" "appserplan" {
  name                = "my-app-service-plan"  # Replace with your app service plan name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "B1"  
  os_type             = "Linux"  
}

resource "azurerm_app_service" "appaser" {
  name                = "revhireappserviceteam4"  
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_service_plan.appserplan.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  site_config {
    always_on = true
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}

resource "azurerm_static_web_app" "example" {
  name                = var.static_web_app_name  # Replace with your static web app name
  resource_group_name = azurerm_resource_group.main.name
  location            = "eastus2"  # Set to an available region for static web app
  tags = {
    environment = "development"
  }
}
