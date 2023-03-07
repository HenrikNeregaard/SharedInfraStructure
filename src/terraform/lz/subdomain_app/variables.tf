variable "environment" {
  type = string
}

variable "domain" {
  description = "The domain of the infrastructure"
  type        = string
}

variable "sub_domain_name" {
}

variable "location" {
  description = "location of data platform."
  default     = "WestEurope"
}

variable "ad" {
  type = object({
    local_tennant                 = string
    ad_datalake_admin_group       = object({ object_id = string, id = string, display_name = string })
    ad_datalake_admin_group_users = map(object({ user_principal_name = string, object_id = string }))
    ad_current_client             = object({ object_id = string })

    subdomains = map(object({
      ad_group_subdomain_owner      = object({ object_id = string, id = string, display_name = string })
      ad_group_subdomain_data_owner = object({ object_id = string, id = string, display_name = string })
      ad_catalog_reader             = object({ object_id = string, id = string, display_name = string })
      ad_spn                        = object({ object_id = string, application_id = string })
      ad_spn_password               = object({ value = string })
    }))
  })
}

variable "subdomain_infra" {
  type = object({
    storage_container   = object({ name = string })
    storage             = object({ id = string, name = string, primary_dfs_endpoint = string })
    rg                  = object({ id = string })
    kv                  = object({ id = string })
    dbw                 = object({ workspace_url = string, id = string, workspace_id = string })
    adf_identity_system = object({ principal_id = string })
    adf                 = object({ id = string })
  })
}

variable "resource_names" {
  type = object({
    ad_domain_owner = string
    subdomains = map(object({
      dbw_catalog_name    = string
      ad_group_owner      = string
      ad_workspace_access = string
      ad_sql_access       = string
    }))
  })
}

variable "dbw_metastore" {
  type = object({ id = string })
}
