
output "resources" {
  value = {
    adf = local.adf
    # adf_identity        = local.adf_identity
    adf_identity_system = local.adf_identity_system
    dbw                 = local.dbw
    kv                  = local.kv
    storage             = local.storage
    storage_container   = local.storage_container_userland
    rg                  = local.resource_group_subdomain
  }
}
