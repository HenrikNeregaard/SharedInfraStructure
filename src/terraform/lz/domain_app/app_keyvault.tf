locals {
  keyvault_key_officers = toset(var.ad.ad_domain_owners)
}

resource "azurerm_key_vault_access_policy" "secretOfficers" {
  for_each     = local.keyvault_key_officers
  key_vault_id = local.keyvault.id
  object_id    = each.key
  tenant_id    = var.ad.local_tennant

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
}

resource "azurerm_key_vault_access_policy" "adfReadSecrets" {
  key_vault_id = local.keyvault.id
  object_id    = local.adf_identity_id
  tenant_id    = var.ad.local_tennant

  secret_permissions = [
    "Get",
    "List",
  ]
}
