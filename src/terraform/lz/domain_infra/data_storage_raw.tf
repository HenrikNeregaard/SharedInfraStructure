locals {
  storage_raw_owners = {
    dladmin = var.ad.ad_domain_owner_group.object_id,
  }
  storage_raw_readers = {
    domain_spn = var.ad.spn_domain_serice_principal.object_id,
  }
  storage_raw_contributors = {
    domain_adf = local.adf_identity_system.principal_id,
  }

  storage_raw_sa_name                = var.resource_names.storage-raw
  storage_raw_container_raw_name_def = var.resource_names.storage-raw-container

  storage_raw                  = module.storage_raw.storage_account
  storage_raw_container_raw_id = module.storage_raw.containers[local.storage_raw_container_raw_name_def]
}

module "storage_raw" {
  source = "../modules/storage"

  location = var.location

  storage_account_name = local.storage_raw_sa_name
  resource_group_name  = local.resource_group_data.name
  storage_access_tier  = "Cool"
  containers           = [local.storage_raw_container_raw_name_def]
  owners               = tomap(local.storage_raw_owners)
  readers              = tomap(local.storage_raw_readers)
  contributors         = tomap(local.storage_raw_contributors)

  subnet_ids = [local.subnet_shared.id, local.subnet_dbw_private.id, local.subnet_dbw_public.id]
  ip_rules   = local.nsg_ip_rules
}

resource "azurerm_monitor_diagnostic_setting" "storage_raw_blob" {
  name                       = "${local.storage_raw_sa_name}_blob"
  target_resource_id         = "${local.storage_raw.id}/blobServices/default"
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
