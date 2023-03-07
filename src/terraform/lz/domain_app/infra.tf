locals {
  dbw                                = var.domain_infra.dbw
  dbw_metastore                      = var.dbw_metastore
  keyvault                           = var.domain_infra.keyvault
  adf_identity_id                    = var.domain_infra.adf_identity_system.principal_id
  adf                                = var.domain_infra.adf
  storage_raw                        = var.domain_infra.storage_raw
  storage_raw_container_raw_name_def = var.domain_infra.storage_raw_container_raw_name_def
}
