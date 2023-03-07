# copy data from sql dataset to csv dataset


resource "azurerm_data_factory_pipeline" "generic_delta_dump_to_csv" {
  name            = "${var.name}_generic_delta_csv_sql_copy"
  data_factory_id = data.azurerm_data_factory.adf.id
  parameters = {
    "table_name"          = "dbo.agent_events",
    "file_name"           = "",
    "system_name"         = "",
    "delta_column_filter" = "dte_updated", #"merge_ids"           = "agent_id",
    "sink_rows_per_file"  = 100000,
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
                        "value": "@concat('SELECT * from ', pipeline().parameters.table_name, ' WHERE ', pipeline().parameters.delta_column_filter, ' > ''', formatDateTime(adddays(utcnow(),-20),'yyyy-MM-dd'),'''')",
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
                        "maxRowsPerFile": {
                            "value": "@pipeline().parameters.sink_rows_per_file",
                            "type": "Expression"
                        },
                        "quoteAllText": true,
                        "fileExtension": ".csv"
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
                        "file_name": "@pipeline().parameters.file_name", 
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

output "generic_delta_dump_pipeline" {
  value = azurerm_data_factory_pipeline.generic_delta_dump_to_csv 
}
