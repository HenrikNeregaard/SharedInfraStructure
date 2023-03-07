locals {
  #   // Gives 32 subnets of same size 23
  subnet_cidr_newbits       = 5
  subnet_cidr_shared_netnum = 31
  subnet_dbw_private_index  = 0
  subnet_dbw_public_index   = 1

  subnet_counts = 30

  subnet_service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.EventHub"]
  subnet_dbw_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]

  subnet_basename        = "${var.resource_names.subnet}-"
  subnet_shared_name_def = "${local.subnet_basename}shared"
  subnet_dbw_name_def    = "${local.subnet_basename}dbw-"
  subnet_shared_cidr = [cidrsubnet(
    local.vnet_adress_space,
    local.subnet_cidr_newbits,
    local.subnet_cidr_shared_netnum,
  )]

  subnet_shared         = azurerm_subnet.Shared
  subnet_dbw_private    = azurerm_subnet.dbw_subnets[local.subnet_dbw_private_index]
  subnet_dbw_public     = azurerm_subnet.dbw_subnets[local.subnet_dbw_public_index]
  subnet_dbw            = azurerm_subnet.dbw_subnets
  subnet_dbw_subdomains = slice(local.subnet_dbw, 2, length(azurerm_subnet.dbw_subnets))

  subnet_subdomains_subnets_used_by_domain     = 2
  subnet_subdomains_subnets_used_by_subdomains = 2

  subnet_subdomains = { for subdomain_name in keys(var.resource_names.subdomains) :
    subdomain_name =>
    slice(
      local.subnet_dbw_subdomains,
      tonumber(var.resource_names.subdomains[subdomain_name].index) * local.subnet_subdomains_subnets_used_by_subdomains,
      (tonumber(var.resource_names.subdomains[subdomain_name].index) + 1) * local.subnet_subdomains_subnets_used_by_subdomains
    )
  }
}

resource "azurerm_subnet" "dbw_subnets" {
  count                = local.subnet_counts
  name                 = "${local.subnet_dbw_name_def}${count.index}"
  resource_group_name  = local.resource_group_infrastructure.name
  virtual_network_name = local.vnet.name

  address_prefixes = [cidrsubnet(
    local.vnet_adress_space,
    local.subnet_cidr_newbits,
    count.index,
  )]
  service_endpoints = local.subnet_service_endpoints

  delegation {
    name = "dbw-delegation"
    service_delegation {
      actions = local.subnet_dbw_actions
      name    = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "Shared" {
  name                 = local.subnet_shared_name_def
  resource_group_name  = local.resource_group_infrastructure.name
  virtual_network_name = local.vnet.name
  address_prefixes     = local.subnet_shared_cidr

  service_endpoints = local.subnet_service_endpoints
}
