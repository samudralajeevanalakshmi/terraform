output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "mysql_flexible_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
}

output "static_web_app_url" {
  value = azurerm_static_site.static_web_app.default_hostname
}
