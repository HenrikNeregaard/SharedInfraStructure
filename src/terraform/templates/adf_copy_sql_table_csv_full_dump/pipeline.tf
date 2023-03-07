
resource "azurerm_data_factory_pipeline" "pipeline" {
  name            = var.name
  data_factory_id = data.azurerm_data_factory.adf.id
  variables = {
    "tables"      = jsonencode(var.tables),
    "system_name" = var.system_name,
    "catalog"     = "${var.domain}_${var.environment}_curation",
  }
  concurrency     = 1
  folder          = var.grouping
  activities_json = <<JSON
    [
        {
            "name": "table_loop",
            "type": "ForEach",
            "dependsOn": [],
            "userProperties": [],
            "typeProperties": {
                "items": {
                    "value": "@json(variables('tables'))",
                    "type": "Expression"
                },
                "activities": [
                    {
                        "name": "Execute_copy_pipeline",
                        "description": "",
                        "type": "ExecutePipeline",
                        "dependsOn": [],
                        "userProperties": [],
                        "typeProperties": {
                            "pipeline": {
                                "referenceName": "${var.copy_pipeline.name}",
                                "type": "PipelineReference"
                            },
                            "waitOnCompletion": true,
                            "parameters": {
                                "system_name": "${var.system_name}",
                                "table_name": {
                                    "value": "@item()",
                                    "type": "Expression"
                                }
                            }
                        }
                    }
                ]
            }
        },
        {
                "name": "Import_to_curation",
                "type": "DatabricksNotebook",
                "dependsOn": [
                    {
                        "activity": "table_loop",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "0.12:00:00",
                    "retry": 3,
                    "retryIntervalInSeconds": 300,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "notebookPath": "/templates/csv_to_curation_infered.py",
                    "baseParameters": {
                        "tables": {
                            "value": "@variables('tables')",
                            "type": "Expression"
                        },
                        "system_name": {
                            "value": "@variables('system_name')",
                            "type": "Expression"
                        },
                        "catalog": {
                            "value": "@variables('catalog')",
                            "type": "Expression"
                        }
                    }
                },
                "linkedServiceName": {
                    "referenceName": "databricks-smallest",
                    "type": "LinkedServiceReference"
                }
            }
    ]
  JSON
}
