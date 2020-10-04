output "firewall_id" {
    value = [for x in azurerm_firewall.this : x.id]   
    }
 output "firewall_ip" {
    value = [for x in azurerm_public_ip.this : x.ip_address]   
    }
output "firewall_name" {
    value = [for x in azurerm_firewall.this : x.name]   
    }
   