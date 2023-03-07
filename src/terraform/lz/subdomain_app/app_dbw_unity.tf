
resource "databricks_metastore_assignment" "subdomain" {
  metastore_id = local.dbw_metastore.id
  workspace_id = local.dbw.workspace_id

  provider = databricks.subdomain
}

resource "databricks_catalog" "subdomain" {
  metastore_id = local.dbw_metastore.id
  name         = local.subdomain_names.dbw_catalog_name
  comment      = "this catalog is managed by terraform"
  owner        = local.ad_sub_domain_data_owner_group.display_name

  depends_on = [
    databricks_metastore_assignment.subdomain
  ]

  provider = databricks.subdomain
}

resource "databricks_grants" "subdomain_catalog_usage" {
  catalog = databricks_catalog.subdomain.name
  grant {
    principal  = local.ad_sub_domain_data_owner_group.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = local.ad_sub_domain_owner_group.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = local.ad_sub_domain_catalog_reader.display_name
    privileges = ["USE_CATALOG"]
  }

  provider = databricks.subdomain
}
