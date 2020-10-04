variable "resource_group_name" {
  description = "(Required) resource group name of private dns a record."
  type        = string
}

variable "dns_arecord_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - Private DNS Zone
# -
variable "dns_a_records" {
  type = map(object({
    a_record_name = string
    dns_zone_name = string
    ttl           = number
    ip_addresses  = list(string)
  }))
  description = "Map containing Private DNS A Records Objects"
  default     = {}
}

variable "a_records_depends_on" {
  type        = any
  description = "Resoure/Module on which DNS A Record module depends on"
  default = null
}
