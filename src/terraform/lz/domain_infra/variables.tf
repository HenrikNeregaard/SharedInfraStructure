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

variable "resource_names" {
  type = object({
    monitor_action_group_alert_data_engineers_name = string

    vnet_delegation         = string
    vnet                    = string
    subnet                  = string
    storage-unity-container = string
    storage-unity           = string
    storage-raw-container   = string
    storage-raw             = string
    storage-logs            = string
    spn                     = string
    rg-infrastructure       = string
    rg-dbw                  = string
    rg-data                 = string
    rg-application          = string
    nsg-dbw                 = string
    nsg                     = string
    kv                      = string
    dbw_metastore           = string
    dbw                     = string
    adf                     = string
    ad_domain_owner         = string
    ad_domain_data_owner    = string
  })
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
  })
}

variable "shared_infra" {
  type = object({
    vnet                    = object({ id = string })
    subnet_shared           = object({ id = string })
    subnet_dbw              = list(object({ id = string, name = string }))
    securityRules           = map(object({ ipRange = string, priority = number }))
    rg_infra                = object({ id = string, name = string, location = string })
    nsg_dbw                 = list(object({ id = string }))
    nsg_ip_rules            = list(string)
    log_analytics_workspace = object({ id = string })
  })
}
