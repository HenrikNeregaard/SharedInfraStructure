locals {
  nsg_base_name = var.resource_names.nsg
  nsg_dbw_name  = var.resource_names.nsg-dbw
  nsg_security_rules = tomap({
    Radius-Virum = {
      ipRange  = "194.28.248.113"
      priority = 101
    }
    Seas-Haslev = {
      ipRange  = "212.178.178.65"
      priority = 102
    }
    seas-Vpn = {
      ipRange  = "62.198.63.196"
      priority = 103
    }

    Radius-Vpn = {
      ipRange  = "152.73.244.7"
      priority = 104
    }
  })

  //noinspection HILUnresolvedReference
  nsg_ip_rules = [for rule in local.nsg_security_rules : rule.ipRange]

  nsg                         = azurerm_network_security_group.base
  nsg_shared_association      = azurerm_subnet_network_security_group_association.shared
  nsg_dbw                     = azurerm_network_security_group.dbw
  nsg_dbws                    = azurerm_subnet_network_security_group_association.dbw_subnets
  nsg_dbw_association_private = local.nsg_dbws[local.subnet_dbw_private_index]
  nsg_dbw_association_public  = local.nsg_dbws[local.subnet_dbw_private_index]

  nsg_dbw_subdomains = slice(local.nsg_dbws, 2, length(local.nsg_dbws))
  nsg_subdomains = { for subdomain_name in keys(var.resource_names.subdomains) :
    subdomain_name =>
    slice(
      local.nsg_dbw_subdomains,
      tonumber(var.resource_names.subdomains[subdomain_name].index) * local.subnet_subdomains_subnets_used_by_subdomains,
      (tonumber(var.resource_names.subdomains[subdomain_name].index) + 1) * local.subnet_subdomains_subnets_used_by_subdomains
    )
  }
}


resource "azurerm_network_security_group" "base" {
  name                = local.nsg_base_name
  location            = local.resource_group_infrastructure.location
  resource_group_name = local.resource_group_infrastructure.name
}

resource "azurerm_network_security_group" "dbw" {
  name                = local.nsg_dbw_name
  location            = local.resource_group_infrastructure.location
  resource_group_name = local.resource_group_infrastructure.name
}

resource "azurerm_network_security_rule" "base" {
  for_each = local.nsg_security_rules
  name     = each.key
  //noinspection HILUnresolvedReference
  priority               = each.value.priority
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "*"
  //noinspection HILUnresolvedReference
  source_address_prefix       = each.value.ipRange
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_infrastructure.name
  network_security_group_name = local.nsg.name
  depends_on = [
    azurerm_network_security_group.base
  ]
}

resource "azurerm_subnet_network_security_group_association" "shared" {
  subnet_id                 = local.subnet_shared.id
  network_security_group_id = local.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "dbw_subnets" {
  count                     = local.subnet_counts
  subnet_id                 = local.subnet_dbw[count.index].id
  network_security_group_id = local.nsg_dbw.id
}
# resource "azurerm_subnet_network_security_group_association" "domain_private" {
#   subnet_id                 = local.subnet_dbw_private.id
#   network_security_group_id = local.nsg_dbw.id
# }
