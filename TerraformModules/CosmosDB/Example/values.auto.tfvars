resource_group_name = "resource_group_name" # "<resource_group_name>"

allowed_subnet_names = ["subnet_name"]

cosmosdb_account = {
  database_name                     = "cosmos_db_name"
  offer_type                        = "Standard"
  kind                              = "MongoDB"
  enable_multiple_write_locations   = false
  enable_automatic_failover         = true
  is_virtual_network_filter_enabled = true
  ip_range_filter                   = null
  api_type                          = "MongoDBv3.4"
  consistency_level                 = "BoundedStaleness"
  max_interval_in_seconds           = 300
  max_staleness_prefix              = 100000
  failover_location                 = "eastus"
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
