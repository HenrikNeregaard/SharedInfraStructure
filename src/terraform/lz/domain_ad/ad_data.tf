locals {
  github_domain_spn = var.resource_names.deploymentPrincipalName

  ad_current_client               = data.azuread_client_config.current
  ad_datalake_admin_group         = data.azuread_group.dlAdmins
  ad_datalake_admin_group_users   = data.azuread_user.admin_members
  ad_deployment_service_principal = data.azuread_service_principal.domainSpn

  ad_domain_owners                   = [local.ad_datalake_admin_group.object_id, local.ad_deployment_service_principal.object_id]
  ad_datalake_admins_without_current = [for id in local.ad_datalake_admin_group.members : id if id != local.ad_current_client.object_id]
  ad_domain_owners_flatened = toset(concat(
    local.ad_datalake_admins_without_current,
    [
      local.ad_current_client.object_id,
      local.ad_deployment_service_principal.object_id,
    ],
  ))
  ad_domain_owners_flatened_no_current = toset(concat(
    local.ad_datalake_admins_without_current,
    [
      local.ad_deployment_service_principal.object_id,
    ],
  ))
  local_tennant = data.azuread_client_config.current.tenant_id
}


data "azuread_client_config" "current" {}

data "azuread_service_principal" "domainSpn" {
  display_name = local.github_domain_spn
}

data "azuread_group" "dlAdmins" {
  display_name     = "AAD_Datalake_admins"
  security_enabled = true
}

data "azuread_service_principal" "databricks_scim" {
  display_name = "databricks-Unity-catalog-scim"
}


data "azuread_user" "admin_members" {
  for_each  = toset(data.azuread_group.dlAdmins.members)
  object_id = each.key
}