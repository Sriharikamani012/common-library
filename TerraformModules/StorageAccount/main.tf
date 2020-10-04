# Design Decisions applicable : #1576, #1578, #1579, #1581, #1582, #1583, #1589, #1593
# Design Decisions not applicable : #167, #1590, #1599, #1625

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags = merge(var.sa_additional_tags, data.azurerm_resource_group.this.tags)

  default_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }
  disable_network_rules = {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = null
    virtual_network_subnet_ids = null
  }

  blobs = {
    for b in var.blobs : b.name => merge({
      type         = "Block"
      size         = 0
      content_type = "application/octet-stream"
      source_file  = null
      source_uri   = null
      metadata     = {}
    }, b)
  }

  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]

  sa_principal_ids = flatten([
    for x in azurerm_storage_account.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ]
  ])
}

# -
# - Storage Account
# -
resource "azurerm_storage_account" "this" {
  for_each                  = var.storage_accounts
  name                      = each.value["name"]
  resource_group_name       = data.azurerm_resource_group.this.name
  location                  = data.azurerm_resource_group.this.location
  account_tier              = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "Premium" : split("_", each.value["sku"])[0]
  account_replication_type  = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "LRS" : split("_", each.value["sku"])[1]
  account_kind              = coalesce(lookup(each.value, "account_kind"), "StorageV2")
  access_tier               = lookup(each.value, "access_tier", null)
  enable_https_traffic_only = true # Design Decision #1578, #1579

  # Design Decision #1583
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(lookup(each.value, "assign_identity", false))
    content {
      type = "SystemAssigned"
    }
  }

  # Design Decision #1576
  dynamic "network_rules" {
    for_each = lookup(each.value, "network_rules", null) != null ? [merge(local.default_network_rules, lookup(each.value, "network_rules", null))] : [local.disable_network_rules]
    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  tags = local.tags
}

resource "null_resource" "this" {
  for_each = var.storage_accounts
  triggers = {
    storage_account_id      = azurerm_storage_account.this[each.key].id
    enable_large_file_share = each.value["enable_large_file_share"]
  }
  provisioner "local-exec" {
    command = "az storage account update --name ${each.value["name"]} -g ${data.azurerm_resource_group.this.name} ${coalesce(lookup(each.value, "enable_large_file_share"), false) == true ? "--enable-large-file-share" : ""}"
  }
}

# -
# - Container
# -
resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.value["name"]
  storage_account_name  = each.value["storage_account_name"]
  container_access_type = coalesce(lookup(each.value, "container_access_type"), "private")
  depends_on            = [azurerm_storage_account.this]
}

# -
# - Blob
# -
resource "azurerm_storage_blob" "this" {
  for_each               = local.blobs
  name                   = each.value["name"]
  storage_account_name   = each.value["storage_account_name"]
  storage_container_name = each.value["storage_container_name"]
  type                   = each.value["type"]
  size                   = lookup(each.value, "size", null)
  content_type           = lookup(each.value, "content_type", null)
  source_uri             = lookup(each.value, "source_uri", null)
  metadata               = lookup(each.value, "metadata", null)
  depends_on             = [azurerm_storage_account.this, azurerm_storage_container.this]
}

# -
# - Queue
# -
resource "azurerm_storage_queue" "this" {
  for_each             = var.queues
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on           = [azurerm_storage_account.this]
}

# -
# - File Share
# -
resource "azurerm_storage_share" "this" {
  for_each             = var.file_shares
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  quota                = coalesce(lookup(each.value, "quota"), 110)
  depends_on           = [azurerm_storage_account.this]
}

# -
# - Table
# -
resource "azurerm_storage_table" "this" {
  for_each             = var.tables
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on           = [azurerm_storage_account.this]
}

# -
# - Create Key Vault Accesss Policy for SA MSI
# - Design Decision #1583
# -
resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.sa_principal_ids)
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.sa_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_storage_account.this]
}

# -
# - Enabled Customer Managed Key Encryption for Storage Account
# -
locals {
  cmk_enabled_sa_ids = [
    for sa_k, sa_v in var.storage_accounts :
    azurerm_storage_account.this[sa_k].id if coalesce(lookup(sa_v, "cmk_enable"), false) == true && length(keys(azurerm_storage_account.this)) > 0
  ]
  mk_enabled_sa_names = [
    for sa_k, sa_v in var.storage_accounts :
    azurerm_storage_account.this[sa_k].name if coalesce(lookup(sa_v, "cmk_enable"), false) == true && length(keys(azurerm_storage_account.this)) > 0
  ]
  cmk_enable_storage_accounts = [
    for sa_k, sa_v in var.storage_accounts :
    sa_k if coalesce(lookup(sa_v, "cmk_enable"), false) == true
  ]
}

# Design Decision #1582
resource "azurerm_key_vault_key" "this" {
  count        = length(local.cmk_enable_storage_accounts)
  name         = element(local.mk_enabled_sa_names, count.index)
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on   = [azurerm_storage_account.this]
}

# Design Decision #1581, #1589
resource "azurerm_storage_account_customer_managed_key" "this" {
  count              = length(local.cmk_enable_storage_accounts)
  storage_account_id = element(local.cmk_enabled_sa_ids, count.index)
  key_vault_id       = var.key_vault_id
  key_name           = element(local.mk_enabled_sa_names, count.index)
  key_version        = element(azurerm_key_vault_key.this.*.version, count.index)
  depends_on         = [azurerm_storage_account.this, azurerm_key_vault_key.this]
}

# -
# - SA Private Endpoints
# -
locals {
  sa_pe_list = flatten([
    for sa_k, sa_v in var.storage_accounts :
    [
      for service in sa_v.sa_pe_enabled_services :
      [
        {
          id                       = "${sa_k}-${service}"
          name                     = "${azurerm_storage_account.this[sa_k].name}-${service}"
          resource_name            = sa_k
          subnet_name              = sa_v.sa_pe_subnet_name
          vnet_name                = sa_v.sa_pe_vnet_name
          approval_required        = sa_v.sa_pe_is_manual_connection
          approval_message         = null
          group_ids                = [service]
          dns_zone_name            = "privatelink.${service}.core.windows.net"
          zone_exists              = false
          zone_to_vnet_link_exists = false
          dns_a_records = [{
            name         = "${azurerm_storage_account.this[sa_k].name}-${service}"
            ttl          = null
            ip_addresses = null
          }]
        }
      ]
    ] if length(keys(azurerm_storage_account.this)) > 0
  ])

  sa_pe_map = {
    for pe in local.sa_pe_list : pe.id => pe
  }

  resource_ids = {
    for sa_k, sa_v in var.storage_accounts : sa_k => azurerm_storage_account.this[sa_k].id if length(keys(azurerm_storage_account.this)) > 0
  }
}

# -
# - SA Private Endpoints for Blob, Queue and Table
# -
module "SAPrivateEndpoint" {
  source              = "../PrivateEndpoint"
  private_endpoints   = local.sa_pe_map
  resource_group_name = data.azurerm_resource_group.this.name
  additional_tags     = var.sa_additional_tags
  subnet_ids          = var.subnet_ids
  vnet_ids            = var.vnet_ids
  resource_ids        = local.resource_ids
}
