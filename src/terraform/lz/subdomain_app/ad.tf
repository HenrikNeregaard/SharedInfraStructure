locals {
  local_tennant                  = var.ad.local_tennant
  ad_subdomain                   = var.ad.subdomains[var.sub_domain_name]
  ad_sub_domain_owner_group      = local.ad_subdomain.ad_group_subdomain_owner
  ad_sub_domain_data_owner_group = local.ad_subdomain.ad_group_subdomain_data_owner
  ad_sub_domain_catalog_reader   = local.ad_subdomain.ad_catalog_reader

  ad_datalake_admin_group                  = var.ad.ad_datalake_admin_group
  spn_sub_domain_serice_principal          = local.ad_subdomain.ad_spn
  spn_sub_domain_serice_principal_password = local.ad_subdomain.ad_spn_password

}
