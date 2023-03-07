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
  key_vault_name          = module.sharedVariables.kv_adf_name

}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_sql_server
data "azurerm_data_factory" "adf" {
  name                = local.adf_name
  resource_group_name = local.adf_resource_group_name
}

resource "azurerm_data_factory_trigger_schedule" "daily" {
  name            = "${var.system_name}_${var.name}_full_dump"
  data_factory_id = data.azurerm_data_factory.adf.id
  pipeline_name   = azurerm_data_factory_pipeline.pipeline.name
  time_zone       = "W. Europe Standard Time"
  activated       = true

  interval  = 1
  frequency = "Day"
  schedule {
    hours   = var.trigger.daily_hour_of_day
    minutes = var.trigger.daily_minutes_of_hour
  }
}
