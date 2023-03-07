

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }


  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
  }

}

provider "azuread" {
}

locals {
  domain      = "jis"
  environment = "dev"
}

module "domain" {
  source      = "../../../domainInfrastructure"
  domain      = local.domain
  environment = local.environment
  location    = "WestEurope"
  providers = {
    azurerm = azurerm
    azuread = azuread
  }
}
module "subdomain" {
  source = "../../../subdomainInfrastructure"

  sub_domain_name   = "tst"
  vnet_subnet_index = 0

  location           = "WestEurope"
  domain             = local.domain
  environment        = local.environment
  domain_info_object = module.domain.for_subdomains
  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  depends_on = [
    module.domain
  ]
}
