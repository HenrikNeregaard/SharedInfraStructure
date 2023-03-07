locals {
  nsg_security_rules = var.shared_infra.securityRules
  nsg_ip_rules       = var.shared_infra.nsg_ip_rules

  nsg_dbws                    = var.shared_infra.nsg_dbw
  nsg_dbw_association_private = local.nsg_dbws[local.subnet_dbw_private_index]
  nsg_dbw_association_public  = local.nsg_dbws[local.subnet_dbw_private_index]


  subnet_dbw_private_index = 0
  subnet_dbw_public_index  = 1

  subnet_shared      = var.shared_infra.subnet_shared
  subnet_dbw_private = var.shared_infra.subnet_dbw[local.subnet_dbw_private_index]
  subnet_dbw_public  = var.shared_infra.subnet_dbw[local.subnet_dbw_public_index]
  subnet_dbw         = var.shared_infra.subnet_dbw

  vnet = var.shared_infra.vnet

  storage_subnets_with_access = concat(
    [for subnet in local.subnet_dbw : subnet.id],
  [local.subnet_shared.id])
}