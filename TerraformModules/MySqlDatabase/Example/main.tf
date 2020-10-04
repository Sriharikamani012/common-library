locals {
  subnet_names = [for s in module.BaseInfrastructure.map_subnets : s.name]
}

module "MySqlDatabase" {
  source                              = "../../common-library/TerraformModules/MySqlDatabase"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  subnet_ids                          = module.BaseInfrastructure.map_subnet_ids
  key_vault_id                        = module.BaseInfrastructure.key_vault_id
  server_name                         = var.server_name
  database_names                      = var.database_names
  administrator_login_password        = var.administrator_login_password
  administrator_login_name            = var.administrator_user_name
  allowed_subnet_names                = var.allowed_subnet_names
  sku_name                            = var.sku_name
  mysql_version                       = var.mysql_version
  storage_mb                          = var.storage_mb
  backup_retention_days               = var.backup_retention_days
  geo_redundant_backup                = var.geo_redundant_backup
  auto_grow                           = var.auto_grow
  private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  mysql_additional_tags               = var.additional_tags
  firewall_rules                      = var.firewall_rules
  mysql_configurations                = var.mysql_configurations
}
