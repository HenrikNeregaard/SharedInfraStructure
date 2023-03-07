locals {
  # input
  resource_group_data_name_def        = var.resource_names.rg-data
  resource_group_application_name_def = var.resource_names.rg-application

  #output
  resource_group_data           = azurerm_resource_group.data
  resource_group_infrastructure = var.shared_infra.rg_infra
  resource_group_application    = azurerm_resource_group.application
}

resource "azurerm_resource_group" "data" {
  location = var.location
  name     = local.resource_group_data_name_def
}
resource "azurerm_resource_group" "application" {
  location = var.location
  name     = local.resource_group_application_name_def
}