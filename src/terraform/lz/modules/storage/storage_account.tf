locals {
  storage_account = azurerm_storage_account.base
}

resource "azurerm_storage_account" "base" {
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  shared_access_key_enabled = true
  is_hns_enabled            = true
  access_tier               = var.storage_access_tier

  location            = var.location
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name
}


# @TODO Renable ip rules for keyvault

# Allow on premise IP's and network through shared
# resource "azurerm_storage_account_network_rules" "base" {
#   storage_account_id = azurerm_storage_account.base.id

#   default_action             = "Deny"
#   ip_rules                   = var.ip_rules
#   virtual_network_subnet_ids = var.subnet_ids
#   // @TODO Temporary untill we can work out how to disable AzureServices
#   bypass                     = ["Metrics", "Logging", "AzureServices"]
#   // This is what we want down the road
#   # bypass                     = ["Metrics", "Logging"]
# }