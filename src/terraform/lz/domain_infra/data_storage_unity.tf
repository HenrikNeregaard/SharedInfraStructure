locals {
  storage_unity_owners = {
    dladmin = var.ad.ad_datalake_admin_group.object_id,
  }
  storage_unity_readers = {
  }
  storage_unity_contributors = {
    domain_spn = var.ad.spn_domain_serice_principal.object_id,
  }

  storage_unity_sa_name            = var.resource_names.storage-unity
  storage_unity_container_name_def = var.resource_names.storage-unity-container

  storage_unity = module.storage_unity.storage_account
}

module "storage_unity" {
  source = "../modules/storage"

  location = var.location

  storage_account_name = local.storage_unity_sa_name
  resource_group_name  = local.resource_group_data.name
  storage_access_tier  = "Hot"
  containers           = [local.storage_unity_container_name_def]
  owners               = tomap(local.storage_unity_owners)
  readers              = tomap(local.storage_unity_readers)
  contributors         = tomap(local.storage_unity_contributors)
  subnet_ids           = local.storage_subnets_with_access
  ip_rules             = local.nsg_ip_rules
}