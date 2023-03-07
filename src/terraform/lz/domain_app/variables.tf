variable "environment" {
  default = "dev"
}

variable "domain" {
  description = "The domain of the infrastructure"
  default     = "cross"
}

variable "location" {
  description = "location of data platform."
  default     = "WestEurope"
}

variable "ad" {
  type = object({
    local_tennant                 = string
    ad_datalake_admin_group       = object({ id = string, object_id = string, display_name = string })
    ad_domain_owners              = list(string)
    ad_datalake_admin_group_users = map(object({ user_principal_name = string, object_id = string }))
    ad_current_client             = object({ object_id = string })

    ad_domain_owner_group                = object({ id = string, object_id = string, display_name = string })
    ad_domain_data_owner_group           = object({ id = string, object_id = string, display_name = string })
    spn_domain_application               = object({ object_id = string, display_name = string, application_id = string })
    spn_domain_serice_principal          = object({ object_id = string, display_name = string, application_id = string })
    spn_domain_application_password      = object({ value = string })
    spn_domain_serice_principal_password = object({ value = string })

    subdomains = map(object({
      ad_group_subdomain_owner = object({ object_id = string, id = string, display_name = string })
    }))

    catalog_readers  = map(object({ object_id = string, display_name = string }))
    catalog_creaters = map(object({ object_id = string, display_name = string }))
  })
}

variable "domain_infra" {
  type = object({
    dbw                                = object({ id = string, workspace_url = string, workspace_id = string })
    keyvault                           = object({ id = string })
    adf                                = object({ id = string, name = string })
    adf_identity_system                = object({ principal_id = string })
    storage_raw                        = object({ id = string, name = string, primary_dfs_endpoint = string })
    storage_raw_container_raw_name_def = string
  })
}

variable "dbw_metastore" {
  type = object({
    id = string
  })
}

variable "resource_names" {
  type = object({
    dbw_catalogs_names          = list(string)
    dbw_catalog_full_names      = map(string)
    kv_adf_name                 = string
    storage_raw_adf_name_binary = string
    storage_raw_adf_name_csv    = string
  })
}
