# #############################################################################
# # OUTPUTS Azure SQL Server
# #############################################################################

output "azuresql_server_id" {
  value       = azurerm_sql_server.this.id
  description = "The server id of Azure SQL Server"
}

output "azuresql_server_name" {
  value       = azurerm_sql_server.this.name
  description = "The server name of Azure SQL Server"
}

output "azuresql_databases_names" {
  value       = [for x in azurerm_sql_database.this : x.name]
  description = "List of all Azure SQL database resource names"
}

output "azuresql_databases_ids" {
  value       = [for x in azurerm_sql_database.this : x.id]
  description = "The list of all Azure SQL database resource ids"
}
