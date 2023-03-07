terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    databricks = {
      source = "databricks/databricks"
    }

    azuread = {
      source = "hashicorp/azuread"
    }
  }

  required_version = ">= 1.1.0"
}

locals {
  resource_names_subdomain = var.resource_names.subdomains[var.sub_domain_name]
}