locals {
  dbw               = var.subdomain_infra.dbw
  dbw_metastore     = var.dbw_metastore
  storage           = var.subdomain_infra.storage
  storage_container = var.subdomain_infra.storage_container
  kv                = var.subdomain_infra.kv
  adf               = var.subdomain_infra.adf
  rg                = var.subdomain_infra.rg
  adf_identity_id   = var.subdomain_infra.adf_identity_system.principal_id
}
