data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# -
# - Create Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  sku               = var.sku
  retention_in_days = var.retention_in_days

  tags = var.law_additional_tags
}

# -
# - Install the VMInsights solution
# -
resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "VMInsights"
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}
