locals {
  dbwLogMountPoint                = "logs"
  dbw_notebook_template_base_path = "$../../../notebooks/templates/"
}

# @TODO Use databricks secrets instead of the secret directly to handle too many mount replacement updates
# Tasks
# Add databricks secret with the keyvault
# Add client id and secret to keyvault
# Change setup to use those secrets. See terraform mount documentation for guide
resource "databricks_mount" "userland" {
  name = "userland"

  uri = "abfss://${local.storage_container.name}@${local.storage.name}.dfs.core.windows.net"
  extra_configs = {
    "fs.azure.account.auth.type" : "OAuth",
    "fs.azure.account.oauth.provider.type" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id" : local.spn_sub_domain_serice_principal.application_id,
    "fs.azure.account.oauth2.client.secret" : local.spn_sub_domain_serice_principal_password.value,
    "fs.azure.account.oauth2.client.endpoint" : "https://login.microsoftonline.com/${local.local_tennant}/oauth2/token",
    "fs.azure.createRemoteFileSystemDuringInitialization" : "false",
  }

  provider = databricks.subdomain
}
