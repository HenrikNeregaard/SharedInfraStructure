locals {
}

module "ad_group_subdomain_owner" {
  for_each = var.resource_names.subdomains

  source = "../modules/ad_group_with_unity"
  name   = each.value.ad_group_owner
  owners = local.ad_domain_owners_flatened_no_current
}

module "ad_group_subdomain_data_owner" {
  for_each = var.resource_names.subdomains
  source   = "../modules/ad_group_with_unity"
  name     = each.value.ad_group_data_owner
  owners   = local.ad_domain_owners_flatened_no_current
}

module "ad_group_subdomain_workspace_access" {
  for_each = var.resource_names.subdomains
  source   = "../modules/ad_group_with_unity"
  name     = each.value.ad_workspace_access
  owners   = local.ad_domain_owners_flatened_no_current
}

module "ad_group_subdomain_sql_access" {
  for_each = var.resource_names.subdomains
  source   = "../modules/ad_group_with_unity"
  name     = each.value.ad_sql_access
  owners   = local.ad_domain_owners_flatened_no_current
}

#TEMPARORY while still deploying from own machine
resource "azuread_group_member" "current_in_sub_domain_data_owner" {
  for_each         = var.resource_names.subdomains
  group_object_id  = module.ad_group_subdomain_data_owner[each.key].group.id
  member_object_id = local.ad_current_client.object_id
}

resource "azuread_group_member" "admins_in_sub_domain_data_owner" {
  for_each         = var.resource_names.subdomains
  group_object_id  = module.ad_group_subdomain_data_owner[each.key].group.id
  member_object_id = local.ad_datalake_admin_group.object_id
}


module "ad_group_subdomain_catalog_reader" {
  for_each = var.resource_names.subdomains
  source   = "../modules/ad_group_with_unity"
  name     = each.value.ad_catalog_reader
  owners   = local.ad_domain_owners_flatened_no_current
}
