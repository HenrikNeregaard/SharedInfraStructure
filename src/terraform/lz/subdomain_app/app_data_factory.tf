locals {
  adf_storage_linked_services = {
    "userland" : local.storage
  }
}


resource "azurerm_data_factory_linked_service_key_vault" "base" {
  name            = "keyVault"
  data_factory_id = local.adf.id
  key_vault_id    = local.kv.id
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "storage" {
  for_each             = local.adf_storage_linked_services
  name                 = each.key
  data_factory_id      = local.adf.id
  use_managed_identity = true
  url                  = each.value.primary_dfs_endpoint
}

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

  //noinspection HILUnresolvedReference
  new_cluster_config {
    node_type             = each.value.nodeType
    cluster_version       = "10.4.x-scala2.12"
    min_number_of_workers = each.value.size

    #    max_number_of_workers = each.value.size

    driver_node_type = "Standard_D8s_v3"
    log_destination  = "dbfs:/logs"

    custom_tags = {
    }

    spark_config = {
    }

    spark_environment_variables = {
    }
  }
}

# Prepared for private link
# resource "azurerm_data_factory_managed_private_endpoint" "storage_raw" {
#   name               = "userland"
#   data_factory_id    = local.adf.id
#   target_resource_id = local.storage.id
#   subresource_name   = "blob"
# }

resource "azurerm_data_factory_dataset_binary" "raw_binary" {

  name                = "userland_binary"
  data_factory_id     = local.adf.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.storage["userland"].name

  parameters = {
    "System"     = "",
    "table_name" = "",
    "file_name"  = "",
  }

  azure_blob_storage_location {
    container                = local.storage_container.name
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
    path                     = "@concat(dataset().System, '/', dataset().table_name)"
    filename                 = "@dataset().file_name"
  }
}

resource "azurerm_data_factory_dataset_delimited_text" "raw_csv" {

  name                = "userland_csv"
  data_factory_id     = local.adf.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.storage["userland"].name

  parameters = {
    "System"     = "",
    "table_name" = "",
    "file_name"  = "",
  }
  first_row_as_header = true
  row_delimiter       = "\n"

  azure_blob_storage_location {
    container                = local.storage_container.name
    dynamic_path_enabled     = true
    dynamic_filename_enabled = true
    path                     = "@concat(dataset().System, '/', dataset().table_name)"
    filename                 = "@dataset().file_name"
  }
}


resource "azuread_group_member" "adf_in_sub_domain_data_owner" {
  group_object_id  = local.ad_sub_domain_data_owner_group.id
  member_object_id = local.adf_identity_id
}

resource "azurerm_role_assignment" "adf_as_dbw_contributor" {
  scope                = local.dbw.id
  role_definition_name = "Contributor"
  principal_id         = local.ad_sub_domain_owner_group.object_id
}

resource "azurerm_role_assignment" "sub_domain_adf_contributor" {
  scope                = local.rg.id
  role_definition_name = "Data Factory Contributor"
  principal_id         = local.ad_sub_domain_owner_group.object_id
}

resource "azurerm_role_assignment" "sub_domain_data_owner_adf_contributor" {
  scope                = local.adf.id
  role_definition_name = "Contributor"
  principal_id         = local.ad_sub_domain_owner_group.object_id
}