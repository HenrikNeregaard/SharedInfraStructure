locals {
  # input
  resource_group_infrastructure_name_def = var.resource_names.rg-infrastructure

  #output
  resource_group_infrastructure = azurerm_resource_group.infrastructure
}

resource "azurerm_resource_group" "infrastructure" {
  location = var.location
  name     = local.resource_group_infrastructure_name_def
}
