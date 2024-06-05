# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  administrator_login = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password
  sku_name            = "GP_Gen5_2"

  storage {
    storage_size_gb = 20
  }

  backup {
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  network {
    delegated_subnet_id = "subnet-id"  # Specify the subnet ID
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_mysql_flexible_database" "my_database" {
  name                = "mydatabase"
  resource_group_name = azurerm_mysql_flexible_server.mysql_flexible_server.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  collation           = "utf8mb4_general_ci"
}

# Static Web App
resource "azurerm_static_site" "static_web_app" {
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  sku {
    tier = "Free"
  }

  identity {
    type = "SystemAssigned"
  }

  build {
    app_location            = "/"
    api_location            = "api"
    output_location         = "build"
    app_artifact_location   = "build"
  }

  github_action_configuration {
    repo_url      = "https://github.com/yourusername/yourrepo"
    branch        = "main"
    token_secret  = "GITHUB_TOKEN"
  }
}
