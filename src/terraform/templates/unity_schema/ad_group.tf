locals {
  ad_group_owners      = local.ad_datalake_admins_without_current
  ad_group_base_name   = "${module.sharedVariables.catalog_schema_group_base_names[var.catalog]}${var.name}-"
  ad_group_reader_name = "${local.ad_group_base_name}reader"
  ad_group_writer_name = "${local.ad_group_base_name}writer"

  ad_group_reader = module.ad_group_schema_reader.group
  ad_group_writer = module.ad_group_schema_writer.group
}

module "ad_group_schema_reader" {
  source = "../../lz/modules/ad_group_with_unity"
  name   = local.ad_group_reader_name
  owners = local.ad_group_owners

  providers = {
    databricks = databricks.azure_account
  }
}

module "ad_group_schema_writer" {
  source = "../../lz/modules/ad_group_with_unity"
  name   = local.ad_group_writer_name
  owners = local.ad_group_owners
  providers = {
    databricks = databricks.azure_account
  }
}

