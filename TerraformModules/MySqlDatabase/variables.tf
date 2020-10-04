variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the MySQL Server"
}

variable "mysql_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource id to store database server password"
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

# -
# - MY SQL Server
# -
variable "server_name" {
  type        = string
  description = "The name of the MyQL Server"
}

variable "database_names" {
  type        = list(string)
  description = "List of MySQL database names"
}

variable "administrator_login_name" {
  type        = string
  description = "The administrator username of MySQL Server"
  default     = "dbadmin"
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator password of the MySQL Server"
  default     = null
}

variable "allowed_subnet_names" {
  type        = list(string)
  description = "The list of subnet names that the MySQL server will be connected to"
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this MySQL Server"
  default     = "GP_Gen5_2"
}

variable "mysql_version" {
  type        = number
  description = "Specifies the version of MySQL to use. Valid values are 5.6, 5.7, and 8.0"
  default     = 5.7
}

variable "storage_mb" {
  type        = number
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup" {
  type        = string
  description = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
  default     = "Disabled"
}

variable "auto_grow" {
  type        = string
  description = "(Optional) Defines whether autogrow is enabled or disabled for the storage. Valid values are Enabled or Disabled."
  default     = "Disabled"
}

variable "mysql_configurations" {
  type        = map(any)
  description = "Map of MySQL configuration settings to create. Key is name, value is server parameter value"
  default     = {}
}

variable "firewall_rules" {
  type = map(object({
    name             = string # (Required) Specifies the name of the MySQL Firewall Rule. 
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
  }))
  description = "List of MySQL Server firewall rule specification"
  default = {
    "default" = {
      name             = "mysql-firewall-rule-default"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}

variable "private_endpoint_connection_enabled" {
  type        = bool
  description = "Specify if only private endpoint connections will be allowed to access this resource"
  default     = false
}
