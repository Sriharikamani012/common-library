# #############################################################################
# # OUTPUTS Storage Account
# #############################################################################

output "sa_name" {
  value = [for x in azurerm_storage_account.this : x.name]
}

output "sa_id" {
  value = [for x in azurerm_storage_account.this : x.id]
}

output "sa_ids_map" {
  value = { for x in azurerm_storage_account.this : x.name => x.id }
}

output "primary_blob_endpoint" {
  value = [for x in azurerm_storage_account.this : x.primary_blob_endpoint]
}

output "container_id" {
  value = [for c in azurerm_storage_container.this : c.id]
}

output "blob_id" {
  value = [for b in azurerm_storage_blob.this : b.id]
}

output "blob_url" {
  value = [for b in azurerm_storage_blob.this : b.url]
}

output "file_share_id" {
  value = [for s in azurerm_storage_share.this : s.id]
}

output "file_share_url" {
  value = [for s in azurerm_storage_share.this : s.url]
}
