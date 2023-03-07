

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dl-admin-dev"
    storage_account_name = "sadladmindevstates"
    container_name       = "diststate"
    key                  = "prod.terraform.tfstate"
    #    Subscription is forsyningsnet 04
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }

  required_version = ">= 1.1.0"
}

locals {
  domain      = "dist"
  environment = "dev"
  subdomain_index_to_name = {
    "0" : "tst0"
  }
  domain_subscription         = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  admin_plane_subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
}

provider "azuread" {}

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
