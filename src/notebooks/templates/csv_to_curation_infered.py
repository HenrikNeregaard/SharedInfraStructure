# Databricks notebook source

dbutils.widgets.text("tables", "") # JSON array of strings
dbutils.widgets.text("system_name", "") # Will also be used as schema
dbutils.widgets.text("catalog", "")
# COMMAND ----------

system_name = dbutils.widgets.get("system_name")
catalog_name = dbutils.widgets.get("catalog")

import json
tables = json.loads(dbutils.widgets.get("tables"))

basePath = f"/mnt/raw/{system_name}/"
# COMMAND ----------

def load_csv_tabl_from_tablename(tableName):
    tableDf = (
        spark.read
        .format("csv")
        .option("inferschema", True)
        .option("header", True)
        .option("delimiter", ",")
        .load(f"{basePath}/{tableName}/")
    )
    return tableDf

def write_to_unity(tableName, tableDf):
    tableName = tableName.replace(".", "_")
    fullTableName = f"{catalog_name}.{system_name}.{tableName}_infered"
    print("Overwriting table",fullTableName)
    (
        tableDf
        .write
        .format("delta")
        .mode("overwrite")
        .option("overwriteSchema", True)
        .saveAsTable(fullTableName)
    )

def overwriteTable(tableName):
    tableDf = load_csv_tabl_from_tablename(tableName)
    write_to_unity(tableName, tableDf)
   
[overwriteTable(table) for table in tables]
