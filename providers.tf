provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "mysql" {
  endpoint = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
  username = "${var.mysql_admin_username}@${var.mysql_server_name}"
  password = var.mysql_admin_password
  database = "mysql"
}
