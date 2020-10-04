# -
# - Core object
# -
variable "resource_group_name" {
  type        = string
  description = "The Name which should be used for this Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure Region used for resources such as: key-vault, storage-account, log-analytics and resource group."
}

variable "net_location" {
  type        = string
  description = "Network resources location if different than the resource group's location."
  default     = ""
}

variable "net_additional_tags" {
  type        = map(string)
  description = "Additional Network resources tags, in addition to the resource group tags."
  default     = {}
}

# -
# - Virtual Network object
# -
variable "virtual_networks" {
  description = "The virtal networks with their properties."
  type = map(object({
    name          = string
    address_space = list(string)
    dns_servers   = list(string)
    ddos_protection_plan = object({
      id     = string
      enable = bool
    })
  }))
  default = {}
}

variable "vnet_peering" {
  description = "Vnet Peering to the destination Vnet"
  type = map(object({
    destination_vnet_name        = string
    destination_vnet_rg          = string
    vnet_key                     = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  }))
  default = {}
}

# -
# - Subnet object
# -
variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type = map(object({
    name              = string
    vnet_key          = string
    nsg_key           = string
    rt_key            = string
    address_prefix    = string
    pe_enable         = bool
    service_endpoints = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {}
}

# -
# - Route Table object
# -
variable "route_tables" {
  description = "The route tables with their properties."
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = bool
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
  default = {}
}

# -
# - Network Security Group object
# -
variable "network_security_groups" {
  description = "The network security groups with their properties."
  type = map(object({
    name = string
    security_rules = list(object({
      name                         = string
      description                  = string
      direction                    = string
      access                       = string
      priority                     = number
      source_address_prefix        = string
      source_address_prefixes      = list(string)
      destination_address_prefix   = string
      destination_address_prefixes = list(string)
      destination_port_range       = string
      destination_port_ranges      = list(string)
      protocol                     = string
      source_port_range            = string
      source_port_ranges           = list(string)
    }))
  }))
  default = {}
}

# -
# - Log Analytics Workspace
# -
variable "base_infra_log_analytics_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace that will be created as part of Base Infrastructure"
}

variable "sku" {
  type        = string
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 "
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = string
  description = "The workspace data retention in days. Possible values range between 30 and 730"
  default     = 7
}

# -
# - Storage Account
# -
variable "base_infra_storage_accounts" {
  type = map(object({
    name            = string
    sku             = string
    account_kind    = string
    access_tier     = string
    assign_identity = bool
    cmk_enable      = bool
    network_rules = object({
      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
    })
    enable_large_file_share    = bool
    sa_pe_is_manual_connection = bool
    sa_pe_subnet_name          = string
    sa_pe_vnet_name            = string
    sa_pe_enabled_services     = list(string) # ["blob", "table", "queue"]
  }))
  description = "Map of Sorage Accounts that will be created as part of Base Infrastructure"
  default     = {}
}

variable "containers" {
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = string
  }))
  description = "Map of Storage Containers"
  default     = {}
}

variable "blobs" {
  type = map(object({
    name                   = string
    storage_account_name   = string
    storage_container_name = string
    type                   = string
    size                   = number
    content_type           = string
    source_uri             = string
    metadata               = map(any)
  }))
  description = "Map of Storage Blobs"
  default     = {}
}

variable "queues" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storages Queues"
  default     = {}
}

variable "file_shares" {
  type = map(object({
    name                 = string
    storage_account_name = string
    quota                = number
  }))
  description = "Map of Storages File Shares"
  default     = {}
}

variable "tables" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storage Tables"
  default     = {}
}

# -
# - Key Vault
# -
variable "base_infra_keyvault_name" {
  type        = string
  description = "Specifies the name of the Key vault that will be created as part of Base Infrastructure"
}

variable "soft_delete_enabled" {
  type        = bool
  description = "Allow Soft Delete be enabled for this Key Vault"
  default     = true
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Allow purge_protection be enabled for this Key Vault"
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
  default     = null
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Disk Encryption to retrieve secrets from the vault and unwrap keys."
  default     = null
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow Resource Manager to retrieve secrets from the key vault."
  default     = null
}

variable "sku_name" {
  type        = string
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}

variable "network_acls" {
  type = object({
    bypass                     = string       # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
  })
  description = "Specifies values for Key Vault network access"
  default     = null
}

variable "access_policies" {
  type = map(object({
    group_names             = list(string)
    object_ids              = list(string)
    user_principal_names    = list(string)
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))
  description = "A map of access policies for the Key Vault"
  default     = {}
}

variable "diagnostics_storage_account_name" {
  type        = string
  description = "Specifies the name of the Storage Account where Diagnostics Data should be sent"
}
