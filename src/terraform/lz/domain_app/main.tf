terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.4"
    }

    databricks = {
      source                = "databricks/databricks"
      version               = "~> 1.6"
      configuration_aliases = [databricks.azure_account]
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22"
    }
  }

  required_version = ">= 1.1.0"
}
