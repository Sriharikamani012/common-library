locals {
  resource_ids = {
    mysql    = module.MySqlDatabase.mysql_server_id
    azuresql = module.AzureSqlDatabase.azuresql_server_id
    cosmosdb = module.CosmosDB.cosmosdb_id
    keyvault = module.BaseInfrastructure.key_vault_id
  }
}

module "PrivateEndpoint" {
  source              = "../../common-library/TerraformModules/PrivateEndpoint"
  private_endpoints   = var.private_endpoints
  resource_group_name = module.BaseInfrastructure.resource_group_name
  subnet_ids          = module.BaseInfrastructure.map_subnet_ids
  vnet_ids            = module.BaseInfrastructure.map_vnet_ids
  resource_ids        = local.resource_ids
  additional_tags     = var.additional_tags
}
