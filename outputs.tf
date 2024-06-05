output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
  sensitive = true
}

output "mysql_flexible_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
  sensitive = true
}

output "static_web_app_url" {
  value = azurerm_static_site.static_web_app.default_hostname
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
  sensitive = true
}
