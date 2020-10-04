### Example of module consumption

module "StorageAccount" {   
  source              = "../../common-library/TerraformModules/StorageAccount"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
  sa_additional_tags  = var.tags
  # you can also consume the key vault id from base infra module as below
  key_vault_id       =  module.BaseInfrastructure.key_vault_id
  subnet_ids         =  module.BaseInfrastructure.map_subnet_ids 
  subnet_ids          = var.subnet_ids
  vnet_ids =  module.BaseInfrastructure.map_vnet_ids
 }