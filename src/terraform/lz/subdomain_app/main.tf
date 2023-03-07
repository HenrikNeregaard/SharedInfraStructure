terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.azure_account, databricks.subdomain]
    }

    azuread = {
      source = "hashicorp/azuread"
    }
  }

  required_version = ">= 1.1.0"
}

locals {
  subdomain_names = var.resource_names.subdomains[var.sub_domain_name]
}