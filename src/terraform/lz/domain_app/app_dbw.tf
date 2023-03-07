locals {
  dbw_notebook_template_base_path = "${path.module}/../../../notebooks/templates/"
}

# @TODO Use databricks secrets instead of the secret directly to handle too many mount replacement updates
# Tasks
# Add databricks secret with the keyvault
# Add client id and secret to keyvault
# Change setup to use those secrets. See terraform mount documentation for guide
resource "databricks_mount" "raw" {
  name = "raw"

  uri = "abfss://${local.storage_raw_container_raw_name_def}@${local.storage_raw.name}.dfs.core.windows.net"
  extra_configs = {
    "fs.azure.account.auth.type" : "OAuth",
    "fs.azure.account.oauth.provider.type" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id" : var.ad.spn_domain_serice_principal.application_id,
    "fs.azure.account.oauth2.client.secret" : var.ad.spn_domain_serice_principal_password.value,
    "fs.azure.account.oauth2.client.endpoint" : "https://login.microsoftonline.com/${var.ad.local_tennant}/oauth2/token",
    "fs.azure.createRemoteFileSystemDuringInitialization" : "false",
  }
}

data "databricks_spark_version" "latest" {
  long_term_support = false
  #photon = true
}
data "databricks_node_type" "smallest" {
  local_disk          = false
  is_io_cache_enabled = true
}

resource "databricks_directory" "templates" {
  path = "/templates"
}

resource "databricks_notebook" "templates" {
  for_each = fileset(local.dbw_notebook_template_base_path, "*")
  source   = "${local.dbw_notebook_template_base_path}/${each.value}"
  path     = "${databricks_directory.templates.id}/${each.value}"
}

resource "databricks_permissions" "templates" {
  directory_path = databricks_directory.templates.id

  access_control {
    group_name       = "users"
    permission_level = "CAN_READ"
  }
}

# @TODO lav default SQL warehouse