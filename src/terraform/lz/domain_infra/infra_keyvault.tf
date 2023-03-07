locals {
  keyvault_Name = var.resource_names.kv

  keyvault = azurerm_key_vault.base
}

resource "azurerm_key_vault" "base" {
  name                = local.keyvault_Name
  resource_group_name = local.resource_group_application.name

  location  = var.location
  sku_name  = "standard"
  tenant_id = var.ad.local_tennant

  // This creates issues with databricks
  enable_rbac_authorization = false

  # @TODO Renable ip rules for keyvault
  #   network_acls {
  #     // Need bypass to allow Databricks to access.
  #     bypass                     = "AzureServices"
  #     default_action             = "Deny"
  #     ip_rules                   = local.ipRules
  #     virtual_network_subnet_ids = local.allSubnets
  #   }
}

resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = local.keyvault_Name
  target_resource_id         = local.keyvault.id
  log_analytics_workspace_id = var.shared_infra.log_analytics_workspace.id

  log {
    category_group = "allLogs"
    enabled        = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }
  log {
    category_group = "audit"
    enabled        = false
    retention_policy {
      enabled = false
      days    = 0
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = false
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}
