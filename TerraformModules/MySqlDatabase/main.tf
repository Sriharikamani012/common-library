resource "random_string" "this" {
  length           = 32
  special          = true
  override_special = "/@"
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags                         = merge(var.mysql_additional_tags, data.azurerm_resource_group.this.tags)
  administrator_login_password = var.administrator_login_password == null ? random_string.this.result : var.administrator_login_password
}

# -
# - MY SQL Server
# -
resource "azurerm_mysql_server" "this" {
  name                = var.server_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku_name            = var.sku_name

  storage_profile {
    storage_mb            = var.storage_mb
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup  = var.geo_redundant_backup
    auto_grow             = var.auto_grow
  }

  administrator_login          = var.administrator_login_name
  administrator_login_password = local.administrator_login_password
  version                      = var.mysql_version
  ssl_enforcement              = "Enabled"

  tags = local.tags

  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

# -
# - MY SQL Databases
# -
resource "azurerm_mysql_database" "this" {
  count               = length(var.database_names)
  name                = element(var.database_names, count.index)
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Configuration/Server Parameters
# -
resource "azurerm_mysql_configuration" "this" {
  for_each            = var.mysql_configurations
  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  value               = each.value
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Virtual Network Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_virtual_network_rule" "this" {
  count               = var.private_endpoint_connection_enabled == false ? length(var.allowed_subnet_names) : 0
  name                = "mysql-vnet-rule-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  subnet_id           = lookup(var.subnet_ids, element(var.allowed_subnet_names, count.index), null)
  depends_on          = [azurerm_mysql_server.this, null_resource.this]
}

# -
# - MY SQL Firewall Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_firewall_rule" "this" {
  for_each            = var.private_endpoint_connection_enabled == false ? var.firewall_rules : {}
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on          = [azurerm_mysql_server.this, null_resource.this]
}

# -
# - MY SQL Allow/Deny Public Network Access
# - Only private endpoint connections will be allowed to access this resource if "private_endpoint_connection_enabled" variable is set to true
# - 
resource "null_resource" "this" {
  triggers = {
    mysql_server_id                     = azurerm_mysql_server.this.id
    private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  }
  provisioner "local-exec" {
    command = "az mysql server update --name ${azurerm_mysql_server.this.name} --resource-group ${data.azurerm_resource_group.this.name} --public-network-access ${var.private_endpoint_connection_enabled ? "Disabled" : "Enabled"}"
  }
}

# -
# - Add MY SQL Server Admin Login Password to Key Vault secrets
# - 
resource "azurerm_key_vault_secret" "this" {
  name         = azurerm_mysql_server.this.name
  value        = local.administrator_login_password
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_mysql_server.this]
}
