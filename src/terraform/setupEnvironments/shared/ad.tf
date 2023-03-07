

data "azuread_client_config" "current" {}

data "azuread_group" "dlAdmins" {
  display_name = module.sharedVariables.aad_admin_group_name
}