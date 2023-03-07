
locals {
  adf_storage_linked_services = {
    raw = local.storage_raw
    # gdpr             = local.storage_gdpr
    # storage_non_gdpr = local.storage_non_gdpr
  }
  adf_identity_app_id = data.azuread_service_principal.adf_identity_app_data.application_id
  # adf_identity_app_id = var.domain_infra.adf_identity.principal_id
}

resource "azurerm_data_factory_linked_service_key_vault" "base" {
  name            = var.resource_names.kv_adf_name
  data_factory_id = local.adf.id
  key_vault_id    = local.keyvault.id
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "storage" {
  for_each             = local.adf_storage_linked_services
  name                 = "storage-${each.key}"
  data_factory_id      = local.adf.id
  use_managed_identity = true
  url                  = each.value.primary_dfs_endpoint
}

data "azuread_service_principal" "adf_identity_app_data" {
  object_id = local.adf_identity_id
}

## @TODO Lav cluster
resource "databricks_cluster" "temp_adf_table" {
  cluster_name            = "temp_adf_tbl"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  data_security_mode      = "SINGLE_USER"
  single_user_name        = local.adf_identity_app_id
  # single_user_name        = data.azuread_service_principal.adf_identity_app_data.application_id


  autoscale {
    min_workers = 1
    max_workers = 2
  }
}

## @TODO brug cluster til at køre databricks

resource "azurerm_data_factory_linked_service_azure_databricks" "msi_linkedAdb" {
  for_each = {
    smallest = {
      nodeType = "Standard_f4"
      size     = 1
    }
    small = {
      nodeType = "Standard_E8s_v3"
      size     = 2
    }
    medium = {
      nodeType = "Standard_E16s_v3"
      size     = 2
    }
    large = {
      nodeType = "Standard_E32s_v3"
      size     = 3
    }
  }
  name            = "databricks-${each.key}"
  data_factory_id = local.adf.id
  #  resource_group_name = azurerm_resource_group.application.name
  description = "Createst for ${each.key} workloads"
  adb_domain  = "https://${local.dbw.workspace_url}"

  msi_work_space_resource_id = local.dbw.id
  existing_cluster_id        = databricks_cluster.temp_adf_table.cluster_id

  # new_cluster_config {
  #   node_type             = each.value.nodeType
  #   cluster_version       = "10.4.x-scala2.12"
  #   min_number_of_workers = each.value.size

  #   #    max_number_of_workers = each.value.size

  #   driver_node_type = "Standard_D8s_v3"
  #   log_destination  = "dbfs:/logs"

  #   custom_tags = {
  #   }

  #   spark_config = {
  #   }

  # #   #    max_number_of_workers = each.value.size

  # }

  #   custom_tags = {}
  #   spark_config = {}
  #   spark_environment_variables = {}
  # }
}



resource "azurerm_data_factory_dataset_binary" "raw_binary" {

  name                = var.resource_names.storage_raw_adf_name_binary
  data_factory_id     = local.adf.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.storage["raw"].name

  parameters = {
    "System"     = "",
    "table_name" = "",
    "file_name"  = "",
  }

  azure_blob_storage_location {
    container                = local.storage_raw_container_raw_name_def
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
    path                     = "@concat(dataset().System, '/', dataset().table_name)"
    filename                 = "@dataset().file_name"
  }
}

resource "azurerm_data_factory_dataset_delimited_text" "raw_csv" {

  name                = var.resource_names.storage_raw_adf_name_csv
  data_factory_id     = local.adf.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.storage["raw"].name

  parameters = {
    "System"     = "",
    "table_name" = "",
    "file_name"  = "",
  }
  first_row_as_header = true
  row_delimiter       = "\n"

  azure_blob_storage_location {
    container                = local.storage_raw_container_raw_name_def
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
    path                     = "@concat(dataset().System, '/', dataset().table_name)"
    filename                 = "@dataset().file_name"
  }
}

resource "azuread_group_member" "adf_app_in_domain_data_owner" {
  group_object_id  = var.ad.ad_domain_data_owner_group.id
  member_object_id = local.adf_identity_id
}

resource "azurerm_role_assignment" "adf_dbw" {
  principal_id         = local.adf_identity_id
  scope                = local.dbw.id
  role_definition_name = "Contributor"
}
