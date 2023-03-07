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
  required_version = ">= 1.1.0"
}

locals {
  domain          = var.domain
  environment     = var.environment
  subdomain_names = values(var.subdomain_index_to_name)

  location = "WestEurope"

  # Hard coded PLEASE FIX
  metastore = {
    id   = "5f9d0b1f-bd50-4b00-8695-58e65969cffa"
    name = "dbw-dl-em-prd"
  }
  databricks_account_console_id = "3b989acc-af3b-4933-b27b-a3fe07933489"
}

provider "azurerm" {
  subscription_id = var.domain_subscription_id
  features {
  }
}
provider "azurerm" {
  alias           = "admin_plane"
  subscription_id = var.admin_plane_subscription_id
  features {
  }
}



provider "databricks" {
  alias      = "azure_account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = local.databricks_account_console_id
  auth_type  = "azure-cli"
}



#region sharedInfra
module "resource_names" {
  source = "../../sharedVariables"

  domain                   = local.domain
  environment              = local.environment
  subdomains_index_to_name = var.subdomain_index_to_name
}

module "ad" {
  source = "../../lz/domain_ad"

  resource_names = module.resource_names

  providers = {
    azuread    = azuread
    databricks = databricks.azure_account

  }
}

module "shared_infra" {
  source = "../../lz/shared_infra"

  domain         = local.domain
  environment    = local.environment
  location       = local.location
  resource_names = module.resource_names

  providers = {
    azurerm             = azurerm
    azuread             = azuread
    azurerm.admin_plane = azurerm.admin_plane
  }
}
#endregion sharedInfra

#region domain
module "domain_infra" {
  source = "../../lz/domain_infra"

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
    module.shared_infra,
    module.ad,
  ]
}

provider "databricks" {
  host = module.domain_infra.resources.dbw.workspace_url
}

module "domain_app" {
  source = "../../lz/domain_app"

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

# Unable to create dynamic amount of subdomains.
# Fixed this by hardcoding them, but making them conditional

