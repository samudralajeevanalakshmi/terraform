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

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "production"
    costcenter  = "team4"
  }
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "loganalyticsworkspace"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"

  retention_in_days = 30

  tags = {
    environment = "production"
    costcenter  = "team4"
  }
}

# Diagnostic Setting
resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "diagsetting"
  target_resource_id = azurerm_resource_group.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log {
    category = "Administrative"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "Security"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "ServiceHealth"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

# Azure Security Center
resource "azurerm_security_center_subscription_pricing" "standard_pricing" {
  tier = "Standard"
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-team4"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
    costcenter  = "team4"
  }
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
    environment = "production"
    costcenter  = "team4"
  }
}

# Static Web App
resource "azurerm_static_site" "static_web_app" {
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku_tier            = "Standard"  # Updated to a supported tier

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "production"
    costcenter  = "team4"
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
    environment = "production"
    costcenter  = "team4"
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
    environment = "production"
    costcenter  = "team4"
  }
}
