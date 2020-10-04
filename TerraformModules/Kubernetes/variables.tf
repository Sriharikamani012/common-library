variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault"
}

variable k8s_cluster {
  type = object({
    name = string
    dns_prefix            = string
    kubernetes_version    = string
    service_address_range = string
    dns_ip                = string
  })
}

variable k8s_client_id {
  type = string
}
variable k8s_client_secret {
  type = string
}

variable default_pool_subnet_id {
  type = string
}

variable log_analytics_workspace_id {
  type    = string
  default = null
}

variable "k8s_default_pool" {
  description = "(Required in 2.0) default_pool (only one allowed in 2.6.0)"
  type        = any
}

variable "k8s_extra_node_pools" {
  description = "(Optional) List of additional node pools"
  type        = any
}