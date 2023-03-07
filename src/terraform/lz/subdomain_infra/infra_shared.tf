locals {
  vnet = var.shared_infra.vnet

  shared_infra_subdomain = var.shared_infra.subnet_subdomains[var.sub_domain_name]
  shared_infra_nsg       = var.shared_infra.nsg_subdomains[var.sub_domain_name]

  subnet_dbw_private       = local.shared_infra_subdomain[0]
  subnet_dbw_public        = local.shared_infra_subdomain[1]
  nsgs_association_private = local.shared_infra_nsg[0]
  nsgs_association_public  = local.shared_infra_nsg[1]

  subnet_shared = var.shared_infra.subnet_shared
  ip_rules      = var.shared_infra.nsg_ip_rules
}
