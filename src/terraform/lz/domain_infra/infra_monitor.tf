resource "azurerm_monitor_action_group" "alert_de" {
  name                = var.resource_names.monitor_action_group_alert_data_engineers_name
  resource_group_name = local.resource_group_application.name
  short_name          = var.resource_names.monitor_action_group_alert_data_engineers_name

  email_receiver {
    name          = "send_to_de"
    email_address = "chedm@forsyningsnet.dk"
  }
}

# Find metrics to monitor here 
# https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftdatafactoryfactories
resource "azurerm_monitor_metric_alert" "Any_Failed" {
  name                = "Alert data engineers"
  resource_group_name = local.resource_group_application.name
  scopes              = [local.adf.id]
  description         = "Monitor failures and report"
  severity            = 2

  window_size = "PT6H"
  frequency   = "PT1H"
  enabled     = true

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "PipelineFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "Name"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_de.id
  }
}
