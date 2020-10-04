module "LoadBalancer" {
  source                  = "../../common-library/TerraformModules/LoadBalancer"
  load_balancers          = var.Lbs
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  zones                   = var.zones #based on zones LB SKU will change
  subnet_ids              = module.BaseInfrastructure.map_subnet_ids
  lb_additional_tags      = var.additional_tags
  load_balancer_rules     = var.LbRules
  load_balancer_nat_rules = var.LbNatRules
  lb_outbound_rules       = var.lb_outbound_rules   
}