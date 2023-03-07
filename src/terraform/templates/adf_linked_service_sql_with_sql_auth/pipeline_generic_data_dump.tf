# copy data from sql dataset to csv dataset


resource "azurerm_data_factory_pipeline" "generic_dump_to_csv" {
  name            = "${var.name}_generic_csv_sql_copy"
  data_factory_id = data.azurerm_data_factory.adf.id
  parameters = {
    "table_name"  = "dbo.queues",
    "system_name" = "",
  }
  folder          = var.grouping
  concurrency     = 50 # Can be run from multiple places at once with no issues
  activities_json = <<JSON
    [
        {
            "name": "copy_data",
            "type": "Copy",
            "dependsOn": [],
            "policy": {
                "timeout": "0.12:00:00",
                "retry": 3,
                "retryIntervalInSeconds": 30,
                "secureOutput": false,
                "secureInput": false
            },
            "userProperties": [],
            "typeProperties": {
                "source": {
                    "type": "SqlServerSource",
                    "sqlReaderQuery": {
                        "value": "@concat('SELECT * from ', pipeline().parameters.table_name)",
                        "type": "Expression"
                    },
                    "queryTimeout": "02:00:00",
                    "partitionOption": "None"
                },
                "sink": {
                    "type": "DelimitedTextSink",
                    "storeSettings": {
                        "type": "AzureBlobFSWriteSettings"
                    },
                    "formatSettings": {
                        "type": "DelimitedTextWriteSettings",
                        "quoteAllText": true,
                        "fileExtension": ".txt"
                    }
                },
                "enableStaging": false,
                "translator": {
                    "type": "TabularTranslator",
                    "typeConversion": true,
                    "typeConversionSettings": {
                        "allowDataTruncation": true,
                        "treatBooleanAsNumber": false
                    }
                }
            },
            "inputs": [
                {
                    "referenceName": "${azurerm_data_factory_dataset_sql_server_table.table.name}",
                    "type": "DatasetReference"
                }
            ],
            "outputs": [
                {
                    "referenceName": "${module.sharedVariables.storage_raw_adf_name_csv}",
                    "type": "DatasetReference",
                    "parameters": {
                        "System": {
                            "value": "@pipeline().parameters.system_name",
                            "type": "Expression"
                        },
                        "file_name": "data.csv",
                        "table_name": {
                            "value": "@pipeline().parameters.table_name",
                            "type": "Expression"
                        }
                    }
                }
            ]
        }
    ]
  JSON
}

output "generic_dump_pipeline" {
  value = azurerm_data_factory_pipeline.generic_dump_to_csv
}


# resource "azurerm_data_factory_pipeline" "pipeline" {
#   name            = var.name
#   data_factory_id = azurerm_data_factory.adf.id
#   variables = {
#     "tables" = jsonencode(var.tables)
#   }
#   folder = var.grouping
#   activities_json = <<JSON
#   [
#     {
#       "name": "Extract all tables",
#       "type": "ForEach",
#       "dependsOn": [],
#       "userProperties": [],
#       "typeProperties": {
#         "items": {
#           "value": "@variables('tables')",
#           "type": "Expression"
#         },
#         "activities": [
#           {
#             "name": "Extract table",
#             "type": "Copy",
#             "dependsOn": [],
#             "policy": {
#               "timeout": "7.00:00:00",
#               "retry": 0,
#               "retryIntervalInSeconds": 30,
#               "secureOutput": false,
#               "secureInput": false
#             },
#             "userProperties": [],
#             "typeProperties": {
#               "source": {
#                 "type": "SqlServerSource",
#                 "sqlReaderQuery": {
#                   "value": "SELECT * FROM @{item().name}",
#                   "type": "Expression"
#                 },
#                 "queryTimeout": "02:00:00",
#                 "partitionOption": "None"
#               },
#               "sink": {
#                 "type": "DelimitedTextSink",
#                 "storeSettings": {
#                   "type": "AzureBlobFSWriteSettings"
#                 },
#                 "formatSettings": {
#                   "type": "DelimitedTextWriteSettings",
#                   "quoteAllText": true,
#                   "fileExtension": ".txt"
#                 }
#               },
#               "enableStaging": false,
#               "translator": {
#                 "type": "TabularTranslator",
#                 "typeConversion": true,
#                 "typeConversionSettings": {
#                   "allowDataTruncation": true,
#                   "treatBooleanAsNumber": false
#                 }
#               }
#             },
#             "inputs": [
#               {
#                 "referenceName": "Puzzel_generic",
#                 "type": "DatasetReference"
#               }
#             ],
#             "outputs": [
#               {
#                 "referenceName": "raw_csv",
#                 "type": "DatasetReference",
#                 "parameters": {
#                   "System": "Puzzel",
#                   "file_name": "data.csv",
#                   "table_name": {
#                     "value": "@item().name",
#                     "type": "Expression"
#                   }
#                 }
#               }
#             ]
#           }
#         ]
#       }
#     },
#     {
#       "name": "Import to curation",
#       "type": "DatabricksNotebook",
#       "dependsOn": [
#         {
#           "activity": "Extract all tables",
#           "dependencyConditions": [
#             "Succeeded"
#           ]
#         }
#       ],
#       "policy": {
#         "timeout": "7.00:00:00",
#         "retry": 3,
#         "retryIntervalInSeconds": 360,
#         "secureOutput": false,
#         "secureInput": false
#       },
#       "userProperties": [],
#       "typeProperties": {
#         "notebookPath": "/Repos/chedm@forsyningsnet.dk/energi-market-bi/src/Puzzel/curation",
#         "baseParameters": {
#           "tables": {
#             "value": "@string(activity('Get tables').output.value)",
#             "type": "Expression"
#           }
#         }
#       },
#       "linkedServiceName": {
#         "referenceName": "databricks-smallest",
#         "type": "LinkedServiceReference"
#       }
#     }
#   ]
#   JSON
# }