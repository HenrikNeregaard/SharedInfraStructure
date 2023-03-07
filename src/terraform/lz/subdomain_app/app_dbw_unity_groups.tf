locals {
  dbw_group_workspace_access = {
    "subdomain_owner" : {
      group_name       = local.subdomain_names.ad_group_owner
      sql_access       = true
      workspace_access = true
      cluster_creation = true
    },

    "domain_owner" : {
      group_name       = var.resource_names.ad_domain_owner
      sql_access       = true
      workspace_access = true
      cluster_creation = true
    },

    "sql_access" : {
      group_name       = local.subdomain_names.ad_sql_access
      sql_access       = true
      workspace_access = false
      cluster_creation = false
    },
    "workspace_access" : {
      group_name       = local.subdomain_names.ad_workspace_access
      sql_access       = false
      workspace_access = true
      cluster_creation = false
    },
  }
}

data "databricks_group" "groups_in_workspace" {
  for_each     = local.dbw_group_workspace_access
  display_name = each.value.group_name
  provider     = databricks.azure_account
}

data "databricks_group" "dlAdmins" {
  display_name = var.ad.ad_datalake_admin_group.display_name
  provider     = databricks.azure_account
}

# This will probably change to a better resource name soon.
# @TODO keep up to date with latest way of doing this
# This can somtimes give an bad error like requires you to set `host` property (or DATABRICKS_HOST env variable) to result of `databricks_mws_workspaces.this.workspace_url`. 
# This is not true, but rather a syncronization error on databricks side, that the user is not correctly synced yet.
# Just rerun the deployment and it will work.
resource "databricks_mws_permission_assignment" "groups_in_subdomain" {
  for_each     = data.databricks_group.groups_in_workspace
  workspace_id = local.dbw.workspace_id
  principal_id = each.value.id
  permissions  = ["USER"]

  provider = databricks.azure_account
}

resource "databricks_entitlements" "workspace_access" {
  for_each              = local.dbw_group_workspace_access
  workspace_access      = each.value.workspace_access
  databricks_sql_access = each.value.sql_access
  allow_cluster_create  = each.value.cluster_creation
  group_id              = data.databricks_group.groups_in_workspace[each.key].id

  depends_on = [
    databricks_mws_permission_assignment.groups_in_subdomain
  ]
  provider = databricks.subdomain
}

resource "databricks_mws_permission_assignment" "add_admin_groups_in_subdomain" {  
  workspace_id = local.dbw.workspace_id
  principal_id = data.databricks_group.dlAdmins.id
  permissions  = ["ADMIN"]
  provider     = databricks.azure_account
  }
