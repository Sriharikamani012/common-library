variable "resource_group_name" {
  type        = string
  description = "Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group"
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "private_endpoints" {
  type = map(object({
    name                     = string
    subnet_name              = string
    vnet_name                = string
    resource_name            = string
    group_ids                = list(string)
    approval_required        = bool
    approval_message         = string
    dns_zone_name            = string
    zone_exists              = bool
    zone_to_vnet_link_exists = bool
    dns_a_records = list(object({
      name         = string
      ttl          = number
      ip_addresses = list(string)
    }))
  }))
  description = "Map containing Private Endpoint and Private DNS Zone details"
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "vnet_ids" {
  type        = map(string)
  description = "A map of vnet id's"
}

variable "resource_ids" {
  type        = map(string)
  description = "Map of private link service resource id's"
}
