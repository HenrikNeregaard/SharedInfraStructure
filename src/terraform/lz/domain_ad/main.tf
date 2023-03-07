terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.3"
    }
  }

  required_version = ">= 1.1.0"
}


variable "resource_names" {
  type = object({
    spn                     = string
    deploymentPrincipalName = string
    ad_domain_owner         = string
    ad_domain_data_owner    = string

    subdomains = map(object({
      ad_group_owner      = string
      ad_group_data_owner = string
      spn                 = string
      ad_catalog_reader   = string
      ad_workspace_access = string
      ad_sql_access       = string
    }))
    catalog_readers  = map(string)
    catalog_creaters = map(string)
  })
}
