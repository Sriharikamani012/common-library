module "KeyVault" {
  source                          = "../KeyVault"
  resource_group_name             = var.resource_group_name
  name                            = var.name
  soft_delete_enabled             = var.soft_delete_enabled
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  sku_name                        = var.sku_name
  access_policies                 = var.access_policies
  network_acls                    = var.network_acls
  log_analytics_workspace_id      = var.log_analytics_workspace_id
  kv_additional_tags              = var.kv_additional_tags
}