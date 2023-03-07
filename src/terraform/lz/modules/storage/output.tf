output "storage_account" {
  value = azurerm_storage_account.base
}

output "containers" {
  value = azurerm_storage_data_lake_gen2_filesystem.containers
}