#Shared data factory to contain on prem runtime

resource "azurerm_data_factory" "adf" {
  name                = module.sharedVariables.admin_data_factory
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  identity {
    type = "SystemAssigned"
  }
  managed_virtual_network_enabled = true

}