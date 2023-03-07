
resource "azurerm_role_assignment" "account_owners" {
  for_each             = var.owners
  scope                = local.storage_account.id
  role_definition_name = "Owner"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "blob_data_owners" {
  for_each             = var.owners
  scope                = local.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "account_readers" {
  for_each             = var.readers
  scope                = local.storage_account.id
  role_definition_name = "Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "blob_data_readers" {
  for_each             = var.readers
  scope                = local.storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "account_contributor" {
  for_each             = var.contributors
  scope                = local.storage_account.id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  for_each             = var.contributors
  scope                = local.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}