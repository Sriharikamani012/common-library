module "Firewall" {
source                    = "../../common-library/TerraformModules/AzureFirewall"
resource_group_name       = var.resource_group_name
firewalls                 = var.firewalls
subnet_ids                = module.BaseInfrastructure.map_subnet_ids
fw_network_rules          = var.fw_network_rules
fw_nat_rules              = var.fw_nat_rules
fw_application_rules      = var.fw_application_rules
firewall_additional_tags  = var.firewall_additional_tags
}