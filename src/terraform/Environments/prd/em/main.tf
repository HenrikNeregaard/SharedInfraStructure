

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.azure_account]
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dl-admin-prd"
    storage_account_name = "stdladminprdstates"
    container_name       = "emstate"
    key                  = "lz-prod"
    #    Subscription is ???
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }

  required_version = ">= 1.1.0"
}



locals {
  domain      = "em"
  environment = "prd"
  subdomain_index_to_name = {
    "0" : "di"
  }
  admin_plane_subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  domain_subscription         = "e7839bf6-900a-4303-9326-7366ef46407b"
}

module "infra" {
  source                      = "../../domain_template/"
  domain                      = local.domain
  environment                 = local.environment
  subdomain_index_to_name     = local.subdomain_index_to_name
  admin_plane_subscription_id = local.admin_plane_subscription_id
  domain_subscription_id      = local.domain_subscription
  providers = {
    azuread = azuread
  }
}
