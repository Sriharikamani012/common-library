### Example of module consumption

module "LogAnalytics" {
  # validate the source path before executing the module.   
  source              = "../../common-library/TerraformModules/LogAnalytics"
  resource_group_name = var.resource_group_name
  name                = var.name
  sku                 = var.sku              
  retention_in_days   = var.retention_in_days 
  law_additional_tags = var.tags
}


