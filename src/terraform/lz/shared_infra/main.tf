terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 3.4"
      configuration_aliases = [azurerm.admin_plane]
    }

    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }
  }

  required_version = ">= 1.1.0"
}