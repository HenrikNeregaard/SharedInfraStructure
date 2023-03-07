terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  # Change to proper one later
  backend "azurerm" {
    resource_group_name  = "rg-dl-admin-dev"
    storage_account_name = "sadladmindevstates"
    container_name       = "crossstate"
    key                  = "metastore"
    #    Subscription is forsyningsnet 04
    #    Change to proper one later
    subscription_id = "23a6451f-91cd-4df9-a3b0-2ca7b7c24233"
  }
}

variable "location" {
  default = "westEurope"
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = azurerm_databricks_workspace.dbw.workspace_url
  auth_type = "azure-cli"
}

module "naming" {
  source  = "Azure/naming/azurerm"
  suffix  = local.suffix
  version = "0.2.0"
}

locals {
  suffix = ["dl", "metastore", "shared"]

  container_name   = "unity"
  admin_group_name = "AAD_Datalake_admins"
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = var.location
}

resource "azurerm_user_assigned_identity" "base" {
  name                = "${module.naming.user_assigned_identity.name}-databricks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "unity_catalog" {
  name                     = module.naming.storage_account.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  tags                     = azurerm_resource_group.rg.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "unity_catalog" {
  name                  = local.container_name
  storage_account_name  = azurerm_storage_account.unity_catalog.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "managed_identity_storage_blob_contributor" {
  scope                = azurerm_storage_account.unity_catalog.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.base.principal_id
}


# Need databricks workspace to setup metastore
resource "azurerm_databricks_workspace" "dbw" {
  location            = azurerm_resource_group.rg.location
  name                = module.naming.databricks_workspace.name
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "premium"
}

resource "databricks_metastore" "domain" {
  name = azurerm_databricks_workspace.dbw.name
  storage_root = format(
    "abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.unity_catalog.name,
    azurerm_storage_account.unity_catalog.name
  )

  owner         = local.admin_group_name
  force_destroy = true

  delta_sharing_scope                               = "INTERNAL"
  delta_sharing_recipient_token_lifetime_in_seconds = 3600 * 24
  delta_sharing_organization_name                   = azurerm_databricks_workspace.dbw.name
}

resource "databricks_metastore_data_access" "base" {
  metastore_id = databricks_metastore.domain.id
  name         = "${databricks_metastore.domain.id}-default"
  azure_managed_identity {
    access_connector_id = azurerm_user_assigned_identity.base.id
  }

  is_default = true
}
