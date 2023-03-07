

resource "azurerm_key_vault_secret" "spnId" {
  depends_on   = [var.keyvaultAccessId]
  key_vault_id = var.keyvaultId
  name         = "${local.keyBaseName}-spnId"
  value        = azuread_service_principal.base.id
  provider     = azurerm.admin
}

resource "azurerm_key_vault_secret" "spnSecret" {
  depends_on   = [var.keyvaultAccessId]
  key_vault_id = var.keyvaultId
  name         = "${local.keyBaseName}-spnSecret"
  value        = azuread_service_principal_password.base.value
  provider     = azurerm.admin
}

resource "azurerm_key_vault_secret" "spnAppId" {
  depends_on   = [var.keyvaultAccessId]
  key_vault_id = var.keyvaultId
  name         = "${local.keyBaseName}-appId"
  value        = azuread_application.base.application_id
  provider     = azurerm.admin
}

resource "azurerm_key_vault_access_policy" "base" {
  key_vault_id = var.keyvaultId
  object_id    = azuread_service_principal.base.object_id
  tenant_id    = data.azuread_client_config.current.tenant_id
  secret_permissions = [
    "Get",
    "List",
  ]
  provider = azurerm.admin
}

