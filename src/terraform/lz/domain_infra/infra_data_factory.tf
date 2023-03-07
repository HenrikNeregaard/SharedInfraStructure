
locals {
  adf_name_def = var.resource_names.adf

  adf = azurerm_data_factory.base
  # adf_identity        = azurerm_user_assigned_identity.adf
  adf_identity_system = azurerm_data_factory.base.identity[0]
}

resource "azurerm_data_factory" "base" {
  name                = local.adf_name_def
  location            = local.resource_group_application.location
  resource_group_name = local.resource_group_application.name
  identity {
    type = "SystemAssigned"
  }
  managed_virtual_network_enabled = true
}


resource "azurerm_data_factory_managed_private_endpoint" "storage_raw" {
  name               = "raw"
  data_factory_id    = azurerm_data_factory.base.id
  target_resource_id = local.storage_raw.id
  subresource_name   = "blob"
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

