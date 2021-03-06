variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Virtual Machine should exist"
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# -
# - Linux VM's
# -
variable "linux_vms" {
  type = map(object({
    name                             = string
    vm_size                          = string
    zone                             = string
    assign_identity                  = bool
    subnet_name                      = string
    lb_backend_pool_name             = string
    disable_password_authentication  = bool
    source_image_reference_publisher = string
    source_image_reference_offer     = string
    source_image_reference_sku       = string
    source_image_reference_version   = string
    storage_os_disk_caching          = string
    managed_disk_type                = string
    disk_size_gb                     = number
    write_accelerator_enabled        = bool
    internal_dns_name_label          = string
    enable_ip_forwarding             = bool
    enable_accelerated_networking    = bool
    dns_servers                      = list(string)
    static_ip                        = string
    recovery_services_vault_key      = string
    enable_cmk_disk_encryption       = bool
    custom_data_path                 = string
  }))
  description = "Map containing Linux VM objects"
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of network interfaces subnets"
  default     = {}
}

variable "lb_backend_address_pool_map" {
  type        = map(string)
  description = "Map of network interfaces internal load balancers backend pool id's"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "The Id of the Key Vault to which all secrets should be stored"
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

variable "administrator_login_password" {
  type        = string
  description = "Specifies the password associated with the local administrator account"
}

variable "linux_image_id" {
  type        = string
  description = "Specifies the Id of the image which this Virtual Machine should be created from"
  default     = null
}

variable "recovery_services_vaults" {
  type        = map(any)
  description = "Map of recovery services vaults"
  default     = null
}

# -
# - Linux VM Boot Diagnostics
# -
variable "sa_bootdiag_storage_uri" {
  type        = string
  description = "Azure Storage Account Primary Queue Service Endpoint."
}

# -
# - Diagnostics Extensions
# -
variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
}

variable "workspace_id" {
  type        = string
  description = "Log analytics workspace id"
}

variable "workspace_key" {
  type        = string
  description = "Log analytics workspace key"
}

# -
# - Managed Disks
# -
variable "managed_data_disks" {
  type = map(object({
    disk_name                 = string
    vm_name                   = string
    lun                       = string
    storage_account_type      = string
    disk_size                 = number
    caching                   = string
    write_accelerator_enabled = bool
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

# -
# - Windows VM's
# -
variable "windows_vms" {
  type = map(object({
    name                             = string
    vm_size                          = string
    zones                            = string
    assign_identity                  = bool
    subnet_name                      = string
    lb_backend_pool_name             = string
    source_image_reference_publisher = string
    source_image_reference_offer     = string
    source_image_reference_sku       = string
    source_image_reference_version   = string
    storage_os_disk_caching          = string
    managed_disk_type                = string
    disk_size_gb                     = number
    write_accelerator_enabled        = bool
    disk_encryption_set_id           = string
    internal_dns_name_label          = string
    enable_ip_forwarding             = bool
    enable_accelerated_networking    = bool
    dns_servers                      = list(string)
    static_ip                        = string
  }))
  description = "Map containing windows vm's"
  default     = {}
}

variable "windows_image_id" {
  type        = string
  description = "Specifies the Id of the image which this Virtual Machine should be created from"
  default     = null
}
