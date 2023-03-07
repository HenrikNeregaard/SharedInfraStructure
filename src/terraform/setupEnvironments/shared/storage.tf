

resource "azurerm_storage_account" "stateStorage" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = data.azurerm_resource_group.base.location
  name                     = module.sharedVariables.admin_storage_account
  resource_group_name      = data.azurerm_resource_group.base.name
  is_hns_enabled           = true
}

resource "azurerm_role_assignment" "storageOwner" {
  principal_id         = data.azuread_client_config.current.object_id
  scope                = azurerm_storage_account.stateStorage.id
  role_definition_name = "Storage Blob Data Owner"
}

resource "azurerm_role_assignment" "storageAdminBlobOwner" {
  principal_id         = data.azuread_group.dlAdmins.id
  scope                = azurerm_storage_account.stateStorage.id
  role_definition_name = "Storage Blob Data Owner"
}
resource "azurerm_role_assignment" "storageAdminOwner" {
  principal_id         = data.azuread_group.dlAdmins.id
  scope                = azurerm_storage_account.stateStorage.id
  role_definition_name = "Owner"
}