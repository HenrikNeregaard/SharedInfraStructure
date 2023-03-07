terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

locals {

  storage_account_name = var.storage_account_name # "${local.baseStorageAccountName}${var.storage_account_zone}"
}
