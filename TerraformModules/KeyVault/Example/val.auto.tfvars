resource_group_name                = "exampletest" #(Required)
name                               = "exampletest2020"#(Required)
sku_name                           = "standard"            #(Required)
log_analytics_workspace_id         = "84af95d2-52a5-444f-a935-35e8f8e4b81f" #(Required)
enabled_for_deployment             = true             # (Optional)
enabled_for_disk_encryption        = true             # (Optional)
enabled_for_template_deployment    = true             # (Optional)
soft_delete_enabled                = true             # (Optional)
purge_protection_enabled           = true             # (Optional)
kv_additional_tags                 = {             # (Optional)
    "env"        = "dev"
    "costcenter" = "IT"
    }
#-----------------------------------(Optional block)---------------------
network_acls                       = {
    bypass                         = "AzureServices"       # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    default_action                 = "Deny"       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules                       = ["10.5.0.9","10.5.0.10"] # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids     = ["/subscriptions/******/resourceGroups/exampletest/providers/Microsoft.Network/virtualNetworks/test/subnets/test1","/subscriptions/******/resourceGroups/exampletest/providers/Microsoft.Network/virtualNetworks/test/subnets/test2"] # (Optional) One or more Subnet ID's which should be able to access this Key Vault.   
}

#-----------------------------------(Optional block)---------------------
secrets                            = {
    secret1 = {
        name  = "key1"
        value = "value1"
        },
    secret2 = {
        name  = "key2"
        value = "value2"
        } 
}
#-----------------------------------(Optional block)---------------------
access_policies                   =
 {
    group_names                   = ["test1","test2"] #Define it as empty list '[]' if you don't want to crate access policies for azure ad groups
    object_ids                    = ["8341a2eedf","8342a2eedf"]
    user_principal_names          = ["pricipal1","principal2"] #Define it as empty list '[]'if not required
    certificate_permissions       = ["get","list"] #Define it as empty list '[]' if not required
    key_permissions               = ["get","list"]
    secret_permissions            = ["get","list"]
    storage_permissions           = ["get","list"] #Define it as empty list'[]' if not required
  }
