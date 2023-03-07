locals {
}

output "resources" {
  value = {
    dbw                                = local.dbw
    adf                                = local.adf
    keyvault                           = local.keyvault
    storage_raw                        = local.storage_raw
    storage_raw_container_raw_name_def = local.storage_raw_container_raw_name_def
    # adf_identity                       = local.adf_identity
    adf_identity_system   = local.adf_identity_system
    dbw_metastore_name    = local.dbw_metastore_name
    dbw_metastore_storage = local.dbw_metastore_storage
  }
}
