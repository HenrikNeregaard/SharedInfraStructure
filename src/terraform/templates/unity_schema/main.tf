terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.azure_account]
      version               = "~> 1.6"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "sharedVariables" {
  source                   = "../../sharedVariables"
  environment              = var.environment
  domain                   = var.domain
  subdomains_index_to_name = var.subdomains_index_to_name
}
