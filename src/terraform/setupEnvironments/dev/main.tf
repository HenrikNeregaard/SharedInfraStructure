terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dl-admin-dev"
    storage_account_name = "tfdladmindevstate"
    container_name       = "adminstate"
    key                  = "prod.terraform.tfstate"
    #    Subscription is forsyningsnet 04
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }

  required_version = ">= 1.1.0"
}

module "adminResources" {
  source                     = "../shared"
  environment                = "dev"
  subscription               = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  crossSubscriptionId        = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  distributionSubscriptionId = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  energyMarketSubscriptionId = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  #  github_runner_token        = var.github_runner_token
}

#
#variable "github_runner_token" {
#  type        = string
#  description = "(Required) The Github actions self-hosted runner registration token"
#  default     = ""
#}
