output "ad" {
  value = {
    local_tennant                 = local.local_tennant
    ad_datalake_admin_group       = local.ad_datalake_admin_group
    ad_domain_owners              = local.ad_domain_owners
    ad_datalake_admin_group_users = local.ad_datalake_admin_group_users
    ad_current_client             = local.ad_current_client

    ad_domain_owner_group                = local.ad_domain_owner_group
    ad_domain_data_owner_group           = local.ad_domain_data_owner_group
    spn_domain_application               = local.spn_domain_application
    spn_domain_application_password      = local.spn_domain_application_password
    spn_domain_serice_principal          = local.spn_domain_serice_principal
    spn_domain_serice_principal_password = local.spn_domain_serice_principal_password

    subdomains = { for subdomain in keys(var.resource_names.subdomains) : subdomain => {
      ad_group_subdomain_owner      = module.ad_group_subdomain_owner[subdomain].group
      ad_group_subdomain_data_owner = module.ad_group_subdomain_data_owner[subdomain].group
      ad_catalog_reader             = module.ad_group_subdomain_catalog_reader[subdomain].group
      ad_workspace_access           = module.ad_group_subdomain_workspace_access[subdomain].group
      ad_sql_access                 = module.ad_group_subdomain_sql_access[subdomain].group

      ad_app          = azuread_application.sub_domain[subdomain]
      ad_spn          = azuread_service_principal.sub_domain[subdomain]
      ad_spn_password = azuread_service_principal_password.sub_domain[subdomain]
    } }

    catalog_readers  = local.catalog_readers
    catalog_creaters = local.catalog_creaters
  }
}
