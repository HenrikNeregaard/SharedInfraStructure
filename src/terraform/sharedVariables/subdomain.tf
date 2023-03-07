locals {
  subdomain_name_to_index = {
    for subdomain_index in keys(var.subdomains_index_to_name) :
    var.subdomains_index_to_name[subdomain_index] => subdomain_index
  }
}
output "subdomains" {
  value = { for subdomain in keys(local.subdomain_name_to_index) : subdomain => {
    rg                = "${module.naming.resource_group.name}-${subdomain}"
    dbw               = "${module.naming.databricks_workspace.name}-${subdomain}"
    dbw_rg            = "${local.dbw_rg}-${subdomain}"
    adf               = "${module.naming.data_factory.name}-${subdomain}"
    kv                = "${module.naming.key_vault.name}-${subdomain}"
    storage           = "${module.naming.storage_account.name}${subdomain}"
    storage_container = "userland"
    index             = local.subdomain_name_to_index[subdomain]

    spn                 = "${local.baseSpnName}-${subdomain}"
    ad_group_data_owner = "${local.baseAadGroupName}-${subdomain}-data-owner"
    ad_group_owner      = "${local.baseAadGroupName}-${subdomain}-owner"
    ad_catalog_reader   = "${local.baseAadGroupName}-${subdomain}-reader"
    ad_workspace_access = "${local.baseAadGroupName}-${subdomain}-workspace-access"
    ad_sql_access       = "${local.baseAadGroupName}-${subdomain}-sql-access"

    dbw_catalog_name = "${var.domain}_${var.environment}_${subdomain}"

    devops_branch_name     = "main"
    devops_repository_name = "subdomain-${subdomain}-adf"
    devops_root_folder     = "/"
    devops_account_name    = "forsyningsnet"
    devops_project_name    = "MSBI-${var.domain}"
  } }
}
