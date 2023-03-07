locals {
  catalog_readers  = { for key, val in module.ad_group_catalog_readers : key => val.group }
  catalog_creaters = { for key, val in module.ad_group_catalog_creaters : key => val.group }

  subdomain_catalog_groups = flatten([for subdomain, sub_domain_module in module.ad_group_subdomain_owner :
    [for catalog, reader_group in local.catalog_readers : {
      group_id  = reader_group.object_id
      member_id = sub_domain_module.group.object_id
      name      = "${subdomain}-${catalog}"
    }]
  ])
}

module "ad_group_catalog_readers" {
  for_each = var.resource_names.catalog_readers
  source   = "../modules/ad_group_with_unity"
  name     = each.value
  owners   = local.ad_domain_owners_flatened_no_current
}

module "ad_group_catalog_creaters" {
  for_each = var.resource_names.catalog_creaters
  source   = "../modules/ad_group_with_unity"
  name     = each.value
  owners   = local.ad_domain_owners_flatened_no_current
}

resource "azuread_group_member" "catalog_subdomain_readers" {
  for_each         = { for membership in local.subdomain_catalog_groups : membership.name => membership }
  group_object_id  = each.value.group_id
  member_object_id = each.value.member_id
}

resource "azuread_group_member" "catalog_domain_readers" {
  for_each         = local.catalog_readers
  group_object_id  = each.value.object_id
  member_object_id = local.ad_domain_owner_group.object_id
}

resource "azuread_group_member" "catalog_domain_data_owner_reader" {
  for_each         = local.catalog_readers
  group_object_id  = each.value.object_id
  member_object_id = local.ad_domain_data_owner_group.object_id
}

resource "azuread_group_member" "catalog_domain_data_owner_creater" {
  for_each         = local.catalog_creaters
  group_object_id  = each.value.object_id
  member_object_id = local.ad_domain_data_owner_group.object_id
}

# @TODO Added subdomain groups as well