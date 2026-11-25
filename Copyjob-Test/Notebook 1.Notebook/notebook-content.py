# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "6a339dfb-e199-4ce5-993a-82618a70b3f1",
# META       "default_lakehouse_name": "datafactory_lakehouse",
# META       "default_lakehouse_workspace_id": "fc806946-335a-445e-babf-761f54e38f78",
# META       "known_lakehouses": [
# META         {
# META           "id": "6a339dfb-e199-4ce5-993a-82618a70b3f1"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Mapping of parquet files to table names
file_table_mapping = {
           
    "Files/part-00000-93b796dc-08a7-425c-a8a7-f91632812ae9-c000.snappy.parquet": "green_tripdata_2022"
    
}

# Loop through all mappings
for file_path, table_name in file_table_mapping.items():
    print(f"Loading {file_path} -> {table_name}")

    # Read parquet file
    df = spark.read.parquet(file_path)

    # Write as Delta Lakehouse table
    df.write.format("delta") \
        .mode("overwrite") \
        .saveAsTable(table_name)

    print(f"Created table: {table_name}")

print("All parquet files loaded successfully.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
