# Lock state storage so it cannot be deleted why the module has state there
data "azurerm_storage_account" "state_storage" {
  name                = module.resource_names.admin_storage_account
  resource_group_name = module.resource_names.admin_rg
  provider            = azurerm.admin_plane
}

resource "azurerm_management_lock" "lock_state" {
  name       = "${module.resource_names.baseResourceName}-domain"
  scope      = data.azurerm_storage_account.state_storage.id
  lock_level = "CanNotDelete"
  notes      = "Locked because it's used for state"
  provider   = azurerm.admin_plane
}
