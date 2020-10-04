storage_accounts = {
  sa1 = {
    name                       = "example042220"
    # define SKU with combination of values of {(account_tier)_ (account_replication_type)}
    # for example if your account_tier is "Standard" and  account_replication_type is LRS, you should define it as 'Standard_LRS'. 
    sku                        = "Standard_RAGRS" 
    account_kind               = null 
    access_tier                = null
    assign_identity            = true # set this as true to assign MSI to storage account
    cmk_enable                 = true #set this as true to enable encryption of storage account using customer managed key
    network_rules              = null
    sa_pe_enabled_services     = ["table", "queue", "blob"] # service names to which private endpoints needs to be created 
    sa_pe_is_manual_connection = false # set this as true if approval is required for private endpoint connection
    sa_pe_subnet_name          = "proxy" # private endpoint subnet name
    sa_pe_vnet_name            = "test"  # virtual network name to which DNS zones needs to be linked
    }
}

containers = {
    container1 = {
     name      = "test"
     storage_account_name  = "example042220"
     container_access_type = "private"  
    }
}

blobs = {
    blob1 = {
    name                   = "test"
    storage_account_name   = "example042220"
    storage_container_name = "test"
    type                   = null
    size                   = null
    content_type           = null
    source_uri             = null
    metadata               = {}   
    }
}

queues = {
    queue1 = {
    name                 = "test1"
    storage_account_name = "example042220"
    }
}


file_shares = {
   share1 = {
    name                 = "share1"
    storage_account_name = "example042220"
    quota                = "512"
   } 
}

tables = {
    table1 = {
        name = "table1"
        storage_account_name = "example042220"
    }
}
key_vault_id = ""
subnet_ids   = {}
vnet_ids     = {}
tags         = {
  "env" = "dev"
}