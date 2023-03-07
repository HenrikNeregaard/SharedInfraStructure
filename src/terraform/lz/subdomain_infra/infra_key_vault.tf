locals {
  keyvault_name = local.resource_names_subdomain.kv
  kv_secret_officers = {
    admins       = local.ad_datalake_admin_group.object_id
    domain_owner = local.ad_sub_domain_owner_group.object_id
  }

  kv = azurerm_key_vault.base
}


resource "azurerm_key_vault" "base" {
  name                = local.keyvault_name
  resource_group_name = local.resource_group_subdomain.name

  location  = local.resource_group_subdomain.location
  sku_name  = "standard"
  tenant_id = local.local_tennant

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

resource "azurerm_key_vault_access_policy" "secretOfficers" {
  for_each     = local.kv_secret_officers
  key_vault_id = local.kv.id
  object_id    = each.value
  tenant_id    = local.local_tennant

  secret_permissions = [
    "Get",
    "List",
    "Purge",
    "Backup",
    "Delete",
    "Recover",
    "Restore",
    "Set",
  ]
}


resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = local.kv.name
  target_resource_id         = local.kv.id
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