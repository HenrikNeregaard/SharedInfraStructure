locals {
  ad_current_client                  = data.azuread_client_config.current
  ad_datalake_admin_group            = data.azuread_group.dlAdmins
  ad_datalake_admin_group_users      = local.ad_datalake_admin_group.members
  ad_datalake_admins_without_current = [for id in local.ad_datalake_admin_group.members : id if id != local.ad_current_client.object_id]
}

data "azuread_client_config" "current" {}


data "azuread_group" "dlAdmins" {
  display_name     = "AAD_Datalake_admins"
  security_enabled = true
}


# This cheats as it's just data :)
# Should have it's own file but would just be clutter
data "azurerm_data_factory" "adf" {
  name                = module.sharedVariables.adf
  resource_group_name = module.sharedVariables.rg-application
}

data "azuread_service_principal" "adf_identity_app_data" {
  object_id = data.azurerm_data_factory.adf.identity[0].principal_id
}
