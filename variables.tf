variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-resource-group"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "eastus"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "my-aks-cluster"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "myacrteam4"
}

variable "mysql_server_name" {
  description = "Name of the MySQL server"
  type        = string
  default     = "my-mysql-server"
}

variable "mysql_admin_username" {
  description = "Admin username for MySQL"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "Admin password for MySQL"
  type        = string
  default     = "SuperSecret123"
  sensitive   = true
}

variable "static_web_app_name" {
  description = "Name of the Static Web App"
  type        = string
  default     = "my-static-web-app"
}

variable "mysql_database_name" {
  description = "Name of the MySQL database"
  type        = string
  default     = "mydatabase"
}
