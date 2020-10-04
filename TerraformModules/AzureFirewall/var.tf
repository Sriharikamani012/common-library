variable "resource_group_name" {
   description = "Name of the resource group in which Firewall needs to be created" 
}

variable "firewalls" {
 type                  = map(object({
    name               = string
    ip_configuration   = list(object({
    name               = string
    subnet_name        = string
    }))
  }))  
description = "map of Firewalls"    
}

variable "firewall_additional_tags" {
 type        = map(string)   
 description = "map of firewall tags"
 default     = {}   
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
  default     = {}
}


variable "fw_network_rules" {
 type                    = map(object({
    name                 = string
    firewall_key         = string
    priority             = number
    action               = string 
    rules            = list(object({
    name                    = string
    description             = string
    source_addresses        = list(string)
    destination_ports       = list(string)
    destination_addresses   = list(string)
    protocols               = list(string)  
    }))
  }))
  default = {} 
}

variable "fw_nat_rules" {
 type                    = map(object({
    name                 = string
    firewall_key         = string
    priority             = number
    rules            = list(object({
    name                    = string
    description             = string
    source_addresses        = list(string)
    destination_ports       = list(string)
    protocols               = list(string)
    translated_address      = string
    translated_port         = number  
    }))
  }))
  default = {} 
}

variable "fw_application_rules" {
 type                    = map(object({
    name                 = string
    firewall_key         = string
    priority             = number
    action               = string 
    rules              = list(object({
    name                    = string
    description             = string
    source_addresses        = list(string)
    fqdn_tags               = list(string)
    target_fqdns            = list(string)
    protocol                = list(object({
    port                    = number
    type                    = string
    }))  
    }))
  }))
  default = {} 
}