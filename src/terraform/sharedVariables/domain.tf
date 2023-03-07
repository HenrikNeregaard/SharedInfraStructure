locals {
  monitor_action_group_alert_data_engineers_name = substr(replace("de-${local.baseResourceName}", "-", ""), 0, 12)

  dbw_rg = "${module.naming.resource_group.name}-dbw-apprg"

  dbw_catalogs_names = [
    "curation",
    "integration",
    "provisioning",
    "for_purpose",
  ]
  catalog_readers         = { for catalog in local.dbw_catalogs_names : catalog => "${local.baseAadGroupName}-${catalog}-reader" }
  catalog_creaters        = { for catalog in local.dbw_catalogs_names : catalog => "${local.baseAadGroupName}-${catalog}-creater" }
  dbw_catalogs_full_names = { for catalog in local.dbw_catalogs_names : catalog => "${var.domain}_${var.environment}_${catalog}" }

  catalog_schema_group_base_names = { for catalog in local.dbw_catalogs_names : catalog => "${local.baseAadGroupName}-${catalog}-" }

  storage_raw_adf_name        = "raw"
  storage_raw_adf_name_csv    = "${local.storage_raw_adf_name}_csv"
  storage_raw_adf_name_binary = "${local.storage_raw_adf_name}_binary"
}


output "monitor_action_group_alert_data_engineers_name" {
  value = local.monitor_action_group_alert_data_engineers_name
}

output "catalog_schema_group_base_names" {
  value = local.catalog_schema_group_base_names
}

output "baseAadGroupName" {
  value = local.baseAadGroupName
}

output "baseResourceGroupName" {
  value = local.baseResourceGroupName
}
output "baseStorageAccountName" {
  value = local.baseStorageAccountName
}
output "baseResourceName" {
  value = local.baseResourceName
}

output "adf" {
  value = module.naming.data_factory.name
}
output "storage_raw_adf_name_csv" {
  value = local.storage_raw_adf_name_csv
}
output "storage_raw_adf_name_binary" {
  value = local.storage_raw_adf_name_binary
}
output "dbw" {
  value = module.naming.databricks_workspace.name
}
output "dbw_metastore" {
  value = module.naming.databricks_workspace.name
}
output "rg-dbw" {
  value = local.dbw_rg
}
output "kv" {
  value = module.naming.key_vault.name
}
output "kv_adf_name" {
  value = local.adf_keyvault_name
}
output "nsg" {
  value = module.naming.network_security_group.name
}
output "nsg-dbw" {
  value = "${module.naming.network_security_group.name}-dbw"
}

output "vnet" {
  value = module.naming.virtual_network.name
}
output "vnet_delegation" {
  value = module.naming.virtual_network.name
}
output "subnet" {
  value = module.naming.subnet.name
}
output "rg-application" {
  value = "${module.naming.resource_group.name}-application"
}
output "rg-infrastructure" {
  value = "${module.naming.resource_group.name}-infrastructure"
}
output "rg-data" {
  value = "${module.naming.resource_group.name}-data"
}

output "storage-raw" {
  value = "${module.naming.storage_account.name}raw"
}
output "storage-raw-container" {
  value = "raw"
}
output "storage-logs" {
  value = "${module.naming.storage_account.name}logs"
}
output "storage-unity" {
  value = "${module.naming.storage_account.name}unity"
}
output "storage-unity-container" {
  value = "unity"
}

output "spn" {
  value = local.baseSpnName
}

output "ad_domain_data_owner" {
  value = "${local.baseAadGroupName}-data-owner"
}
output "ad_domain_owner" {
  value = "${local.baseAadGroupName}-owner"
}

output "log_analytics_workspace" {
  value = module.naming.log_analytics_workspace.name
}

output "deploymentPrincipalName" {
  value = local.deploymentPrincipalName
}

output "dbw_catalogs_names" {
  value = local.dbw_catalogs_names
}

output "catalog_readers" {
  value = local.catalog_readers
}

output "catalog_creaters" {
  value = local.catalog_creaters
}
output "dbw_catalog_full_names" {
  value = local.dbw_catalogs_full_names
}
