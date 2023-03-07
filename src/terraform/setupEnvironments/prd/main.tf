terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dl-admin-prd"
    storage_account_name = "tfdladminprdstate"
    container_name       = "adminstate"
    key                  = "admin-state"
    #    Subscription is forsyningsnet 04
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }

  required_version = ">= 1.1.0"
}

module "adminResources" {
  source                     = "../shared"
  environment                = "prd"
  subscription               = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  crossSubscriptionId        = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  distributionSubscriptionId = "200303d2-42bb-4200-9a3b-736e262c1a9e"
  energyMarketSubscriptionId = "e7839bf6-900a-4303-9326-7366ef46407b"
}
