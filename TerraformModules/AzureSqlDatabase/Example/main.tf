locals {
  subnet_names = [for s in module.BaseInfrastructure.map_subnets : s.name]
}


module "AzureSqlDatabase" {
  source                              = "../../common-library/TerraformModules/AzureSqlDatabase"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  subnet_ids                          = module.BaseInfrastructure.map_subnet_ids
  key_vault_id                        = module.BaseInfrastructure.key_vault_id
  server_name                         = var.server_name
  database_names                      = var.database_names
  allowed_subnet_names                = var.allowed_subnet_names
  azuresql_version                    = var.azuresql_version
  edition                             = var.edition
  sqldb_service_objective_name        = var.sqldb_service_objective_name
  administrator_login_password        = var.administrator_login_password
  administrator_login_name            = var.administrator_user_name
  enable_failover_server              = var.enable_failover_server
  failover_location                   = var.failover_location
  azuresql_additional_tags            = var.additional_tags
  private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  firewall_rules                      = var.firewall_rules
}
