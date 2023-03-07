terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "sharedVariables" {
  source                   = "../../sharedVariables"
  environment              = var.environment
  domain                   = var.domain
  subdomains_index_to_name = var.subdomains_index_to_name
}

locals {
  adf_name                = module.sharedVariables.adf
  adf_resource_group_name = module.sharedVariables.rg-application
  connection_string       = "Integrated Security=False;Data Source=${var.sql_server_url};Initial Catalog=${var.sql_server_database_name};User ID=${var.sql_username}"
  key_vault_name          = module.sharedVariables.kv_adf_name
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_sql_server
data "azurerm_data_factory" "adf" {
  name                = local.adf_name
  resource_group_name = local.adf_resource_group_name
}

resource "azurerm_data_factory_linked_service_sql_server" "server" {
  name                     = var.name
  data_factory_id          = data.azurerm_data_factory.adf.id
  integration_runtime_name = var.integration_runtime_name

  additional_properties = {}
  annotations           = []
  parameters            = {}

  connection_string = local.connection_string
  key_vault_password {
    linked_service_name = local.key_vault_name
    secret_name         = var.sql_password_keyvault_name
  }
}

# Dynamisk dataset baseret på linked service
resource "azurerm_data_factory_dataset_sql_server_table" "table" {
  name                = "${var.name}_generic"
  data_factory_id     = data.azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.server.name
  folder              = var.grouping
}

output "linked_service" {
  value = azurerm_data_factory_linked_service_sql_server.server
}

output "table" {
  value = azurerm_data_factory_dataset_sql_server_table.table
}

#@TODO Lav data objecter over secret så vi får proaktive fejl. findes secret_name for keyvault? - hvis ikke -> fejl
