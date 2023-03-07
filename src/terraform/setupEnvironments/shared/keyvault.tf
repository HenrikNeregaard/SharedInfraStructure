

resource "azurerm_key_vault" "base" {
  location            = "WestEurope"
  name                = module.sharedVariables.admin_key_vault
  resource_group_name = data.azurerm_resource_group.base.name
  sku_name            = "standard"
  tenant_id           = local.tennantId
}

resource "azurerm_key_vault_access_policy" "secretOfficers" {
  for_each = {
    current = data.azuread_client_config.current.object_id
    admins  = data.azuread_group.dlAdmins.object_id
  }
  key_vault_id = azurerm_key_vault.base.id
  object_id    = each.value
  tenant_id    = data.azuread_client_config.current.tenant_id
  secret_permissions = [
    "Get",
    "List",
    "Purge",
    "Backup",
    "Delete",
    "Recover",
    "Restore",
    "Set",
  ]
  certificate_permissions = [

  ]
}