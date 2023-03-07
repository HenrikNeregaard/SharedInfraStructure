locals {
  ad_domain_owner_group_name      = var.resource_names.ad_domain_owner
  ad_domain_data_owner_group_name = var.resource_names.ad_domain_data_owner

  ad_domain_owner_group      = module.ad_group_domain_owner.group
  ad_domain_data_owner_group = module.ad_group_domain_data_owners.group
}

module "ad_group_domain_owner" {
  source = "../modules/ad_group_with_unity"
  name   = local.ad_domain_owner_group_name
  owners = local.ad_domain_owners_flatened_no_current
}

module "ad_group_domain_data_owners" {
  source = "../modules/ad_group_with_unity"
  name   = local.ad_domain_data_owner_group_name
  owners = local.ad_domain_owners_flatened_no_current
}

#TEMPARORY while still deploying from own machine
resource "azuread_group_member" "current_in_domain_data_owner" {
  group_object_id  = local.ad_domain_data_owner_group.id
  member_object_id = local.ad_current_client.object_id
}

resource "azuread_group_member" "admins_in_domain_data_owner" {
  group_object_id  = local.ad_domain_data_owner_group.id
  member_object_id = local.ad_datalake_admin_group.object_id
}
