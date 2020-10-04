module "Virtualmachine" {
  source                       = "../../common-library/TerraformModules/VirtualMachine"
  resource_group_name          = module.BaseInfrastructure.resource_group_name
  key_vault_id                 = module.BaseInfrastructure.key_vault_id
  linux_vms                    = var.linux_vms
  linux_image_id               = var.linux_image_id
  administrator_user_name      = var.administrator_user_name
  administrator_login_password = var.administrator_login_password
  subnet_ids                   = module.BaseInfrastructure.map_subnet_ids
  lb_backend_address_pool_map  = module.LoadBalancer.pri_lb_backend_map_ids             #(Optional set it to null)
  sa_bootdiag_storage_uri      = module.BaseInfrastructure.primary_blob_endpoint[0] #(Mandatory)
  diagnostics_sa_name          = module.BaseInfrastructure.sa_name[0]
  workspace_id                 = module.BaseInfrastructure.law_workspace_id
  workspace_key                = module.BaseInfrastructure.law_key
  managed_data_disks           = var. managed_data_disks
  vm_additional_tags           = var.additional_tags
}