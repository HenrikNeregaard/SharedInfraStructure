terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.24"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = var.subscription

  features {}
}

provider "github" {
  owner = "andel-bi"
}

provider "azurerm" {
  alias                      = "private_linked"
  subscription_id            = "ce2a7a55-4299-42c3-af6e-cab7e6afef39"
  skip_provider_registration = true
  features {}
}

locals {
  baseAadGroupName = module.sharedVariables.baseAadGroupName
  tennantId        = data.azuread_client_config.current.tenant_id
}

module "sharedVariables" {
  source                   = "../../sharedVariables"
  environment              = var.environment
  domain                   = "admin"
  subdomains_index_to_name = {}
}

data "azurerm_resource_group" "base" {
  name = module.sharedVariables.admin_rg
}