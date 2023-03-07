
locals {
  adf_name_def     = local.resource_names_subdomain.adf
  logRetentionDays = 210

  adf = azurerm_data_factory.base
  # adf_identity        = azurerm_user_assigned_identity.adf
  adf_identity_system = azurerm_data_factory.base.identity[0]
}

resource "azurerm_data_factory" "base" {
  name                = local.adf_name_def
  location            = local.resource_group_subdomain.location
  resource_group_name = local.resource_group_subdomain.name
  identity {
    type = "SystemAssigned"
  }
  managed_virtual_network_enabled = true

  vsts_configuration {
    branch_name     = local.resource_names_subdomain.devops_branch_name
    repository_name = local.resource_names_subdomain.devops_repository_name
    root_folder     = local.resource_names_subdomain.devops_root_folder
    account_name    = local.resource_names_subdomain.devops_account_name
    project_name    = local.resource_names_subdomain.devops_project_name
    tenant_id       = local.local_tennant
  }
}

resource "azurerm_monitor_diagnostic_setting" "adf" {
  name                           = local.adf.name
  target_resource_id             = local.adf.id
  log_analytics_workspace_id     = var.shared_infra.log_analytics_workspace.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category_group = "allLogs"
    enabled        = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }
}
