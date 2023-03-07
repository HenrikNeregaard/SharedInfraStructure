output "resources" {
  value = {
    vnet                    = local.vnet
    subnet_shared           = local.subnet_shared
    subnet_dbw              = local.subnet_dbw
    subnet_subdomains       = local.subnet_subdomains
    nsg_subdomains          = local.nsg_subdomains
    securityRules           = local.nsg_security_rules
    rg_infra                = local.resource_group_infrastructure
    nsg_dbw                 = local.nsg_dbws
    nsg_ip_rules            = local.nsg_ip_rules
    log_analytics_workspace = local.log_analytics_workspace
  }
}
