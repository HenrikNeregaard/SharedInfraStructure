locals {
  log_analytics_workspace_sku       = "PerGB2018"
  log_analytics_workspace_retention = 30

  log_analytics_workspace = azurerm_log_analytics_workspace.shared_infra_logs
}

resource "azurerm_log_analytics_workspace" "shared_infra_logs" {
  name                = module.sharedVariables.admin_log_analytics_workspace
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  sku                 = local.log_analytics_workspace_sku
  retention_in_days   = local.log_analytics_workspace_retention
}
