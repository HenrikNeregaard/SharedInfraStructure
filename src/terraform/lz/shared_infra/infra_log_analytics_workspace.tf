locals {
  log_analytics_workspace_sku       = "PerGB2018"
  log_analytics_workspace_retention = 30

  log_analytics_workspace = data.azurerm_log_analytics_workspace.shared_infra_logs
}

# resource "azurerm_log_analytics_workspace" "shared_infra_logs" {
#   name                = var.resource_names.log_analytics_workspace
#   location            = local.resource_group_infrastructure.location
#   resource_group_name = local.resource_group_infrastructure.name
#   sku                 = local.log_analytics_workspace_sku
#   retention_in_days   = local.log_analytics_workspace_retention
# }

data "azurerm_log_analytics_workspace" "shared_infra_logs" {
  name                = var.resource_names.admin_log_analytics_workspace
  resource_group_name = var.resource_names.admin_rg
  provider            = azurerm.admin_plane
}
