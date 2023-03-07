
data "databricks_group" "dlAdmins" {
  display_name = var.ad.ad_datalake_admin_group.display_name
  provider     = databricks.azure_account
}
data "databricks_group" "domain" {
  display_name = var.ad.ad_domain_owner_group.display_name
  provider     = databricks.azure_account
}


data "databricks_group" "data_owner" {
  display_name = var.ad.ad_domain_data_owner_group.display_name
  provider     = databricks.azure_account
   }

resource "databricks_mws_permission_assignment" "add_admin_group" {  
  workspace_id = local.dbw.workspace_id
  principal_id = data.databricks_group.dlAdmins.id
  permissions  = ["ADMIN"]
  provider     = databricks.azure_account
  }