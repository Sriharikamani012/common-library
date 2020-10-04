resource_group_name = "resource_group_name" # "<resource_group_name>"

private_dns_zones = {
  zone1 = {
    dns_zone_name            = "privatelink.database.windows.net" # <"dns_zone_name">
    vet_name                 = "jstartvmss"                       # <"virtual_network_linked_to_dns_zone">
    zone_exists              = false                              # <true | false>
    zone_to_vnet_link_exists = false                              # <true | false>
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
