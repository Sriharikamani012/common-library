variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the vmss in addition to the resource group tag"
  default     = {}
}

# -
# - Virtual Machine Scaleset
# -
variable "vmss" {
  type = map(object({
    name                             = string
    vm_size                          = string
    zones                            = list(string)
    assign_identity                  = bool
    subnet_name                      = string
    internal_lb_iteration            = number
    enable_autoscaling               = bool
    instances                        = number
    disable_password_authentication  = bool
    source_image_reference_publisher = string
    source_image_reference_offer     = string
    source_image_reference_sku       = string
    source_image_reference_version   = string
    storage_os_disk_caching          = string
    managed_disk_type                = string
    disk_size_gb                     = number
    write_accelerator_enabled        = bool
    enable_cmk_disk_encryption      = bool
    storage_profile_data_disk = list(object({
      lun                       = number
      caching                   = string
      disk_size_gb              = number
      managed_disk_type         = string
      write_accelerator_enabled = bool
      enable_acc_net            = bool
      enable_ip_forward         = bool
    }))
  }))
  description = "Map containing Linux VM Scaleset objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "The username of the local administrator on each Virtual Machine Scale Set instance"
  default     = "adminuser"
}

variable "administrator_login_password" {
  type        = string
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
  default     = []
}

variable "lb_probe_id" {
  type        = list(string)
  description = "load balancers probe ids list"
  default     = []
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of network interfaces subnets"
}

variable "pri_lb_backend_ids" {
  type        = list(string)
  description = "Network Interfaces internal load balancers backend ids list"
  default     = []
}

variable "linux_image_id" {
  type        = string
  description = "The ID of an Image which each Virtual Machine in this Scale Set should be based on"
  default     = null
}

# Boot Diagnostics
variable "sa_bootdiag_storage_uri" {
  type        = string
  description = "Azure Storage Account Primary Queue Service Endpoint"
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault from which all Secrets should be sourced"
}

# Diagnostics Extensions
variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
}

variable "workspace_id" {
  type        = string
  description = "log analytics workspace id"
}

variable "workspace_key" {
  type        = string
  description = "log analytics workspace key"
}
