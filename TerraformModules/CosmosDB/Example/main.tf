locals {
  subnet_names = [for s in module.BaseInfrastructure.map_subnets : s.name]
}

module "CosmosDB" {
  source                   = "../../common-library/TerraformModules/CosmosDB"
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  subnet_ids               = module.BaseInfrastructure.map_subnet_ids
  allowed_subnet_names     = var.allowed_subnet_names
  cosmosdb_additional_tags = var.additional_tags
  cosmosdb_account         = var.cosmosdb_account
}
