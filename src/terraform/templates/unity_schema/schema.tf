locals {
  catalog_name_full = "${var.domain}_${var.environment}_${var.catalog}"
}

resource "databricks_schema" "base" {
  catalog_name  = lower(local.catalog_name_full)
  name          = lower(var.name)
  comment       = "managed by terraform"
  force_destroy = true

  owner = module.sharedVariables.ad_domain_data_owner
}

resource "databricks_grants" "domain_catalog_usage" {
  schema = databricks_schema.base.id

  grant {
    principal  = module.ad_group_schema_reader.group.display_name
    privileges = ["USE_SCHEMA", "SELECT"]
  }

  grant {
    principal  = module.ad_group_schema_writer.group.display_name
    privileges = ["CREATE_TABLE", "CREATE_VIEW", "CREATE_FUNCTION", "MODIFY"]
  }

  grant {
    principal  = module.sharedVariables.aad_admin_group_name
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    module.ad_group_schema_reader,
    module.ad_group_schema_writer
  ]
}
