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

variable "resource_names" {
  type = object({
    subdomains = map(object({
      kv                = string
      rg                = string
      storage           = string
      storage_container = string
      dbw               = string
      dbw_rg            = string
      adf               = string

      devops_branch_name     = string
      devops_repository_name = string
      devops_root_folder     = string
      devops_account_name    = string
      devops_project_name    = string
    }))
  })
}

variable "ad" {
  type = object({
    local_tennant           = string
    ad_datalake_admin_group = object({ object_id = string })

    subdomains = map(object({
      ad_group_subdomain_owner = object({ object_id = string })
      ad_spn                   = object({ object_id = string })
    }))
  })
}

variable "shared_infra" {
  type = object({
    subnet_subdomains       = map(list(object({ id = string, name = string })))
    nsg_subdomains          = map(list(object({ id = string })))
    subnet_shared           = object({ id = string })
    nsg_ip_rules            = list(string)
    vnet                    = object({ id = string })
    log_analytics_workspace = object({ id = string })
  })
}
