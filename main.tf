# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
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
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  depends_on = [azurerm_subnet.aks]
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  administrator_login = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name            = "GP_Gen5_2"

  tags = {
    environment = "production"
  }
}

resource "azurerm_mysql_flexible_database" "my_database" {
  name                = var.mysql_database_name
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

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
