resource_group_name = "resource_group_name" # "<resource_group_name>"

private_endpoints = {
  pe1 = {
    resource_name            = "azuresql"                         # key from the resource_ids Map key-value pairs
    name                     = "privateendpointazuresql"          # <"private_endpoint_name">
    subnet_name              = "proxy"                            # <"private_endpoint_subnet">
    vnet_name                = "jstartvmss"                       # <"vnet_for_private_endoint_subnet"?
    approval_required        = false                              # <true | false>
    approval_message         = null                               # <"approval-request_message_for_manual_approval">
    group_ids                = ["sqlServer"]                      # <["group_ids_for_private_endpoint"]>
    dns_zone_name            = "privatelink.database.windows.net" # <"dns_zone_name_for_this_private_endpoint">
    zone_exists              = false                              # <true | false>
    zone_to_vnet_link_exists = false                              # <true | false>
    dns_a_records = [{                                            # <list_of_dns_a_record_blocks>
      name         = "dns_a_record_name"
      ttl          = 300
      ip_addresses = ["ip_address"]
    }]
  },
  pe2 = {
    resource_name            = "mysql"
    name                     = "privateendpointmysql1"
    subnet_name              = "proxy"
    vnet_name                = "jstartvmssnew"
    approval_required        = false
    approval_message         = null
    group_ids                = ["mysqlServer"]
    dns_zone_name            = "privatelink.mysql.database.azure.com"
    zone_exists              = false
    zone_to_vnet_link_exists = false
    dns_a_records            = null
  },
  pe3 = {
    resource_name            = "cosmosdb"
    name                     = "privateendpointcosmosdb"
    subnet_name              = "proxy"
    vnet_name                = "jstartvmss"
    approval_required        = false
    approval_message         = null
    group_ids                = ["MongoDB"]
    dns_zone_name            = "privatelink.mongo.cosmos.azure.com"
    zone_exists              = false
    zone_to_vnet_link_exists = false
    dns_a_records            = null
  },
  pe4 = {
    resource_name            = "keyvault"
    name                     = "privateendpointkeyvault"
    subnet_name              = "proxy"
    vnet_name                = "jstartvmss"
    approval_required        = false
    approval_message         = null
    group_ids                = ["vault"]
    dns_zone_name            = "privatelink.vaultcore.azure.net"
    zone_exists              = false
    zone_to_vnet_link_exists = false
    dns_a_records            = null
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}

