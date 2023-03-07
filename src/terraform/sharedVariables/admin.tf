output "admin_log_analytics_workspace" {
  value = module.naming_admin.log_analytics_workspace.name
}

output "admin_rg" {
  value = module.naming_admin.resource_group.name
}


output "admin_storage_account" {
  value = "${module.naming_admin.storage_account.name}states"
}

output "admin_key_vault" {
  value = module.naming_admin.key_vault.name
}

output "admin_data_factory" {
  value = module.naming_admin.data_factory.name
}

output "aad_admin_group_name" {
  value = local.aad_admin_group_name
}
