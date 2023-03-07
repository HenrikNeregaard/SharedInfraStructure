locals {
  vnet_name         = var.resource_names.vnet
  vnet_adress_space = "10.0.0.0/18"

  vnet = azurerm_virtual_network.sharedInfraVnet
}

resource "azurerm_virtual_network" "sharedInfraVnet" {
  address_space       = [local.vnet_adress_space]
  location            = local.resource_group_infrastructure.location
  name                = local.vnet_name
  resource_group_name = local.resource_group_infrastructure.name
}


