variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-resource-group-team4"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "eastus"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "my-aks-cluster-team4"
}

variable "mysql_server_name" {
  description = "Name of the MySQL server"
  type        = string
  default     = "my-mysql-server-team4"
}

variable "mysql_admin_username" {
  description = "Admin username for MySQL"
  type        = string
  default     = "mysqladminteam4"
}

variable "mysql_admin_password" {
  description = "Admin password for MySQL"
  type        = string
  default     = "Project123@"
  sensitive   = true
}

variable "static_web_app_name" {
  description = "Name of the Static Web App"
  type        = string
  default     = "my-static-web-app-team4"
}
