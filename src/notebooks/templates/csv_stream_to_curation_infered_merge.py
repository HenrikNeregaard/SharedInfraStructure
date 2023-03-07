# Databricks notebook source

from delta.tables import DeltaTable
import json
# JSON dictionary table name to table config
dbutils.widgets.text("tables", "")
dbutils.widgets.text("system_name", "")  # Will also be used as schema
dbutils.widgets.text("catalog", "")
# COMMAND ----------

system_name = dbutils.widgets.get("system_name")
catalog_name = dbutils.widgets.get("catalog")

tables = json.loads(dbutils.widgets.get("tables"))

basePath = f"/mnt/raw/{system_name}/"
baseCheckpointPath = f"{basePath}_____checkpoints/"
baseSchemasPath = f"{basePath}_____autoloaderSchemas/"
# COMMAND ----------


def stream_csv_table_from_tablename(tableName):
    tableDf = (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "csv")
        # The schema location directory keeps track of your data schema over time
        .option("cloudFiles.schemaLocation", f"{baseSchemasPath}{tableName}")
        .option("cloudFiles.inferColumnTypes", True)
        .option("header", True)
        .option("delimiter", ",")
        .load(f"{basePath}/{tableName}/")
    )
    return tableDf


def merge_table(tableName, dfUpdates, id_columns):
    fullTableName = f"{catalog_name}.{system_name}.{tableName}"
    deltaTable = DeltaTable.forName(spark, fullTableName)
    deltaTable.alias("target").merge(
        dfUpdates.alias("updates"),
        " AND ".join(
            [f"target.{column} = updates.{column}" for column in id_columns]),
    ).whenMatchedUpdateAll().whenNotMatchedInsertAll().execute()


def Ensure_table_exists(tableName, schema):
    if spark.sql(f"SHOW TABLES IN {catalog_name}.{system_name} LIKE '{tableName}'").count == 0:
        emptyDf = spark.createDataFrame(spark.sparkContext.emptyRDD(), schema)
        (
            emptyDf.write.format("delta")
            .mode("overwrite")
            .saveAsTable(tableName)
        )


def update_table_with_microbatch_data(tableName, dfUpdates, id_columns):
    # Remove older updates when multiple messages @TODO update to use latest message
    dfUpdates_without_duplicates = dfUpdates.dropDuplicates()
    Ensure_table_exists(tableName, dfUpdates.schema)
    merge_table(tableName, dfUpdates_without_duplicates, id_columns)


def merge_stream_to_unity(tableName, tableDf, id_columns): #id_columns: list(str)
    tableName = tableName.replace(".", "_")
    fullTableName = f"{tableName}_infered"

    (
        tableDf
        .writeStream
        .option("checkpointLocation", f"{baseCheckpointPath}/{tableName}")
        .trigger(availableNow=True)
        .foreachBatch(lambda df, batchID: update_table_with_microbatch_data(fullTableName, df, id_columns))
        .start()
    )


def update_unity_table(tableName, mergeids):
    tableDf = stream_csv_table_from_tablename(tableName)
    merge_stream_to_unity(tableName, tableDf, mergeids)


[update_unity_table(tables[tables.index(table)]['table_name'], list(table['merge_ids'])) for table in tables]

# tables[table=0]= {
    #   table_name          = "dbo.agent_events"
    #   sink_rows_per_file  = 100000
    #   delta_column_filter = "dte_updated"
    #   merge_ids           = ["agent_id", "rec_id"] #, "usergroup_id"]
    # }
