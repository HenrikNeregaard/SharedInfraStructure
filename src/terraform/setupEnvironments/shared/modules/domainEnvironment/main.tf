terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    github = {
      source = "integrations/github"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = var.subscription
  features {
  }
}
provider "azurerm" {
  subscription_id = var.stateSubscriptionId
  alias           = "admin"
  features {}
}
locals {
  baseResourceName       = module.sharedVariables.baseResourceName
  baseStorageAccountName = module.sharedVariables.baseStorageAccountName
  baseResourceGroupName  = module.sharedVariables.baseResourceGroupName
  baseAadGroupName       = module.sharedVariables.baseAadGroupName
}

module "sharedVariables" {
  source                   = "../../../../sharedVariables"
  environment              = var.environment
  domain                   = var.domain
  subdomains_index_to_name = {}
}

