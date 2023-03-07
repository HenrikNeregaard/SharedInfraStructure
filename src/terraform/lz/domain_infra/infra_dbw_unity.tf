locals {

  dbw_metastore_name = var.resource_names.dbw_metastore
  dbw_metastore_storage = format("abfss://%s@%s.dfs.core.windows.net/",
    local.storage_unity_container_name_def,
  local.storage_unity.name)
}
