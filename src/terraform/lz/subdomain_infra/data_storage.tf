locals {
  storage_owners = {
    dladmin = local.ad_datalake_admin_group.object_id,
  }
  storage_readers = {
  }
  storage_contributors = {
    subdomain_group = local.ad_sub_domain_owner_group.object_id,
    subdomain_spn   = local.spn_sub_domain_serice_principal.object_id,
  }

  storage_sa_name                     = local.resource_names_subdomain.storage
  storage_container_userland_name_def = local.resource_names_subdomain.storage_container
  storage_containers = [
    local.storage_container_userland_name_def,
  ]

  storage                    = module.storage_subdomain.storage_account
  storage_container_userland = module.storage_subdomain.containers[local.storage_container_userland_name_def]
}

module "storage_subdomain" {
  source = "../modules/storage"

  location = local.resource_group_subdomain.location

  storage_account_name = local.storage_sa_name
  resource_group_name  = local.resource_group_subdomain.name
  storage_access_tier  = "Hot"
  containers           = local.storage_containers
  owners               = tomap(local.storage_owners)
  readers              = tomap(local.storage_readers)
  contributors         = tomap(local.storage_contributors)

  subnet_ids = [local.subnet_dbw_private.id, local.subnet_dbw_public.id, local.subnet_shared.id]
  ip_rules   = local.ip_rules
}

resource "azurerm_monitor_diagnostic_setting" "storage_blob" {
  name                       = "${local.storage.name}_blob"
  target_resource_id         = "${local.storage.id}/blobServices/default"
  log_analytics_workspace_id = var.shared_infra.log_analytics_workspace.id

  log {
    category = "StorageWrite"
    enabled  = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true
    retention_policy {
      enabled = true
      days    = local.logRetentionDays
    }
  }

  log {
    category = "StorageRead"
    enabled  = false
    retention_policy {
      enabled = false
      days    = 0
    }
  }
  metric {
    category = "Capacity"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "Transaction"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
