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
    container_name       = "devstate" # manually created
    key                  = "chedm"
    #    Subscription is forsyningsnet 04
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "databricks" {
  alias                = "azure_account"
  host                 = "https://accounts.azuredatabricks.net"
  account_id           = "3b989acc-af3b-4933-b27b-a3fe07933489"
  auth_type            = "azure-cli"
  debug_truncate_bytes = 2048
}

locals {
  domain      = "chedm"
  environment = "dev"
  subdomain_names = [
    "tst0"
  ]

  metastore = {
    id   = "5f9d0b1f-bd50-4b00-8695-58e65969cffa"
    name = "dbw-dl-em-prd"
  }
}

#region sharedInfra
module "resource_names" {
  source = "../../../sharedVariables"

  domain      = local.domain
  environment = local.environment
  subdomains  = local.subdomain_names
}

module "ad" {
  source = "../../../lz/domain_ad"

  resource_names = module.resource_names

  providers = {
    azuread    = azuread
    databricks = databricks.azure_account
  }
}

module "shared_infra" {
  source = "../../../lz/shared_infra"

  domain         = local.domain
  environment    = local.environment
  location       = "WestEurope"
  resource_names = module.resource_names

  providers = {
    azurerm = azurerm
    azuread = azuread
  }
}

#endregion sharedInfra

#region domain
module "domain_infra" {
  source = "../../../lz/domain_infra"

  domain         = local.domain
  environment    = local.environment
  location       = "WestEurope"
  resource_names = module.resource_names
  ad             = module.ad.ad
  shared_infra   = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }
  depends_on = [
    module.shared_infra
  ]
}

provider "databricks" {
  host = module.domain_infra.resources.dbw.workspace_url
}

module "domain_app" {
  source = "../../../lz/domain_app"

  domain         = local.domain
  environment    = local.environment
  location       = "WestEurope"
  ad             = module.ad.ad
  domain_infra   = module.domain_infra.resources
  dbw_metastore  = local.metastore
  resource_names = module.resource_names

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.domain_infra
  ]
}

#endregion domain

#region subdomain0
module "subdomain_0_infra" {
  source = "../../../lz/subdomain_infra"

  sub_domain_name = local.subdomain_names[0]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  resource_names  = module.resource_names
  ad              = module.ad.ad
  shared_infra    = module.shared_infra.resources

  providers = {
    azurerm = azurerm
    azuread = azuread
  }
}
provider "databricks" {
  alias      = "subdomain_0"
  host       = module.subdomain_0_infra.resources.dbw.workspace_url
  account_id = "3b989acc-af3b-4933-b27b-a3fe07933489"
}
module "subdomain_0_app" {
  source = "../../../lz/subdomain_app"

  sub_domain_name = local.subdomain_names[0]
  location        = "WestEurope"
  domain          = local.domain
  environment     = local.environment
  ad              = module.ad.ad
  dbw_metastore   = local.metastore
  resource_names  = module.resource_names
  subdomain_infra = module.subdomain_0_infra.resources

  providers = {
    azurerm                  = azurerm
    azuread                  = azuread
    databricks               = databricks.azure_account
    databricks.subdomain     = databricks.subdomain_0
    databricks.azure_account = databricks.azure_account
  }
  depends_on = [
    module.subdomain_0_infra
  ]
}

#endregion subdomain0

