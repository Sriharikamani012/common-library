resource "random_string" "this" {
  length           = 32
  special          = true
  override_special = "/@"
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags                         = merge(var.azuresql_additional_tags, data.azurerm_resource_group.this.tags)
  administrator_login_password = var.administrator_login_password == null ? random_string.this.result : var.administrator_login_password
}

# -
# - Azure SQL Server
# -
resource "azurerm_sql_server" "this" {
  name                         = var.server_name
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  version                      = var.azuresql_version
  administrator_login          = var.administrator_login_name
  administrator_login_password = local.administrator_login_password
  tags                         = local.tags

  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

# -
# - Azure SQL Databases
# -
resource "azurerm_sql_database" "this" {
  count                            = length(var.database_names)
  name                             = element(var.database_names, count.index)
  resource_group_name              = data.azurerm_resource_group.this.name
  location                         = data.azurerm_resource_group.this.location
  server_name                      = azurerm_sql_server.this.name
  edition                          = var.edition
  requested_service_objective_name = var.sqldb_service_objective_name
  tags                             = local.tags
  depends_on                       = [azurerm_sql_server.this]
}

# -
# - Azure SQL Server Virtual Network Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# -
resource "azurerm_sql_virtual_network_rule" "this" {
  count               = var.private_endpoint_connection_enabled == false ? length(var.allowed_subnet_names) : 0
  name                = "azuresql-vnet-rule-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_sql_server.this.name
  subnet_id           = lookup(var.subnet_ids, element(var.allowed_subnet_names, count.index), null)
  depends_on          = [azurerm_sql_server.this]
}

# -
# - Azure SQL Server Firewall Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# -
resource "azurerm_sql_firewall_rule" "this" {
  for_each            = var.private_endpoint_connection_enabled == false ? var.firewall_rules : {}
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_sql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on          = [azurerm_sql_server.this]
}

# -
# - Azure SQL Allow/Deny Public Network Access
# - Only private endpoint connections will be allowed to access this resource if "private_endpoint_connection_enabled" variable is set to true
# - 
resource "null_resource" "this" {
  triggers = {
    azuresql_server_id                  = azurerm_sql_server.this.id
    private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  }
  provisioner "local-exec" {
    command = "az sql server update --name ${azurerm_sql_server.this.name} --resource-group ${data.azurerm_resource_group.this.name} --enable-public-network ${var.private_endpoint_connection_enabled ? false : true}"
  }
}

# -
# - Add Azure SQL Admin Login Password to Key Vault secrets
# -
resource "azurerm_key_vault_secret" "azuresql_keyvault_secret" {
  name         = azurerm_sql_server.this.name
  value        = local.administrator_login_password
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_sql_server.this]
}

# -
# - Secondary/Failover Azure SQL Server
# -
resource "azurerm_sql_server" "sqlserver_secondary" {
  count                        = var.enable_failover_server ? 1 : 0
  name                         = "${var.server_name}-secondary"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = var.failover_location
  version                      = var.azuresql_version
  administrator_login          = var.administrator_login_name
  administrator_login_password = var.administrator_login_password

  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

# -
# - Azure SQL Server Failover Group
# -
resource "azurerm_sql_failover_group" "this" {
  count               = var.enable_failover_server ? 1 : 0
  name                = "${var.server_name}-failover-group"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_sql_server.this.name
  databases           = azurerm_sql_database.this.*.id

  partner_servers {
    id = element(azurerm_sql_server.sqlserver_secondary.*.id, 0)
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
