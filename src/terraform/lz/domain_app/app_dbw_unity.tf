locals {
  dbw_catalogs_names = var.resource_names.dbw_catalogs_names
}

# Uncommented until catalog isolation where something like this is needed
# resource "databricks_metastore_data_access" "domain" {
#   metastore_id = local.dbw_metastore.id
#   name         = "domain_data_acess"
#   azure_service_principal {
#     directory_id   = var.ad.local_tennant
#     application_id = var.ad.spn_domain_application.application_id
#     client_secret  = var.ad.spn_domain_application_password.value
#   }
#   is_default = true

#   lifecycle {
#     create_before_destroy = false
#   }
# }


resource "databricks_metastore_assignment" "domain" {
  metastore_id = local.dbw_metastore.id
  workspace_id = local.dbw.workspace_id
}

resource "databricks_catalog" "domain" {
  for_each     = var.resource_names.dbw_catalog_full_names
  metastore_id = local.dbw_metastore.id
  name         = each.value
  comment      = "this catalog is managed by terraform"
  # owner        = data.databricks_group.data_owner.display_name # While testing do not set this. Makes it easier

  depends_on = [
    databricks_metastore_assignment.domain
  ]
}

resource "databricks_service_principal" "adf_in_unity" {
  application_id = local.adf_identity_app_id
  display_name   = local.adf.name
  force          = true

  provider = databricks.azure_account
}


resource "databricks_grants" "domain_catalog_usage" {
  for_each = databricks_catalog.domain
  catalog  = each.value.name

  grant {
    principal  = var.ad.catalog_readers[each.key].display_name
    privileges = ["USE_CATALOG"]
  }

  grant {
    principal  = var.ad.catalog_creaters[each.key].display_name
    privileges = ["CREATE_SCHEMA"]
  }
  grant {
    # Data factory "owns" the catalogs, so it can do anything seamlessly
    principal  = local.adf_identity_app_id
    privileges = ["ALL_PRIVILEGES"]
  }
}
