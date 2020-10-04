resource_group_name = "resource_group_name" # "<resource_group_name>"
location            = "eastus2"             # <"azure_region">


# - Base Infrastructure Virtual Network
virtual_networks = {
  virtualnetwork1 = {
    name                 = "jstartvmssfirst"
    address_space        = ["10.0.138.0/24"]
    dns_servers          = null
    ddos_protection_plan = null
  },
  virtualnetwork2 = {
    name                 = "jstartvmsssecond"
    address_space        = ["172.16.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

# - Base Infrastructure Subnets
subnets = {
  subnet1 = {
    vnet_key          = "virtualnetwork1"
    nsg_key           = "nsg1"
    rt_key            = null
    name              = "loadbalancer"
    address_prefix    = "10.0.138.0/28"
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    pe_enable         = false
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    nsg_key           = null
    rt_key            = null
    name              = "proxy"
    address_prefix    = "10.0.138.16/28"
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet3 = {
    vnet_key          = "virtualnetwork1"
    nsg_key           = null
    rt_key            = null
    name              = "application"
    address_prefix    = "10.0.138.32/28"
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  }
}

# - Base Infrastructure Route Tables
route_tables = {}

# - Base Infrastructure Network Security Groups
network_security_groups = {
  nsg1 = {
    name = "nsg1"
    security_rules = [
      {
        name                         = "sample-nsg"
        description                  = "Sample NSG"
        priority                     = 101
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        source_port_ranges           = null
        destination_port_range       = "*"
        destination_port_ranges      = null
        source_address_prefix        = "*"
        source_address_prefixes      = null
        destination_address_prefix   = "*"
        destination_address_prefixes = null
      }
    ]
  }
}

# - Base Infrastructure Log Analytics Workspace 
base_infra_log_analytics_name = "baseloganalytics"
sku                           = "PerGB2018"
retention_in_days             = 30

# - Base Infrastructure Storage Account
base_infra_storage_accounts = {
  sa1 = {
    name                       = "basestorageaccount"
    sku                        = "Standard_RAGRS"
    account_kind               = null
    access_tier                = null
    assign_identity            = true
    cmk_enable                 = true
    network_rules              = null
    sa_pe_is_manual_connection = false
    sa_pe_subnet_name          = "proxy"
    sa_pe_vnet_name            = "jstartvmssone"
    sa_pe_enabled_services     = ["table", "queue", "blob"]
  }
}
containers  = {}
blobs       = {}
queues      = {}
file_shares = {}
tables      = {}

# - Base Infrastructure Key Vault
base_infra_keyvault_name = "basekeyvault"
sku_name                 = "standard"
network_acls = {
  bypass                     = "AzureServices"
  default_action             = "Deny"
  ip_rules                   = ["0.0.0.0/0"]
  virtual_network_subnet_ids = []
}
soft_delete_enabled              = true
purge_protection_enabled         = true
enabled_for_deployment           = null
enabled_for_disk_encryption      = null
enabled_for_template_deployment  = null
access_policies                  = {}
diagnostics_storage_account_name = "basestorageaccount"

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
