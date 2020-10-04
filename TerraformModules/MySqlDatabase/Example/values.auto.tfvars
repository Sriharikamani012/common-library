resource_group_name = "resource_group_name" # "<resource_group_name>"

server_name                         = "mysql_server_name"
database_names                      = ["mysql_database_name"]
administrator_user_name             = "admin_username"
administrator_login_password        = "admin_password"
allowed_subnet_names                = ["subnet_name"]
sku_name                            = "GP_Gen5_2"
mysql_version                       = 5.7
storage_mb                          = 5120
backup_retention_days               = 7
geo_redundant_backup                = "Disabled"
auto_grow                           = "Disabled"
private_endpoint_connection_enabled = true

firewall_rules = {
  "default" = {
    name             = "mysql-firewall-rule-default"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}

mysql_configurations = {
  interactive_timeout = "600"
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
