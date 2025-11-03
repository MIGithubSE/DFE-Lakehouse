# Databricks notebook source
# DFE Education Lakehouse - Setup & Utilities

# COMMAND ----------

# MAGIC %md
# MAGIC # DfE Education Lakehouse - Setup & Configuration
# MAGIC 
# MAGIC Initializes Unity Catalog, schemas, and utility functions for the medallion pipeline.

# COMMAND ----------

# DBTITLE 1,Load Configuration
# Load global configuration
config_path = "/Users/ec09495@yahoo.com/education-lakehouse-pipeline/config/global_config.json"

try:
    with open(config_path, 'r') as f:
        import json
        global_config = json.load(f)
    print("✅ Configuration loaded successfully!")
except Exception as e:
    print(f"⚠️  Could not load config file: {e}")
    print("Using default configuration...")
    global_config = {
        "catalog": {"name": "dfe_education"},
        "schemas": {
            "bronze": {"name": "bronze"},
            "silver": {"name": "silver"}, 
            "gold": {"name": "gold"}
        }
    }

# COMMAND ----------

# DBTITLE 1,Initialize Unity Catalog Environment
from pyspark.sql import functions as F
from pyspark.sql.types import *
from delta.tables import *

def initialize_uc_environment():
    """Initialize Unity Catalog environment for DfE education data"""
    
    # Create catalog if it doesn't exist
    spark.sql(f"""
        CREATE CATALOG IF NOT EXISTS {global_config['catalog']['name']}
        COMMENT 'DFE Education Data Lakehouse - Unity Catalog'
    """)
    
    # Use the catalog
    spark.sql(f"USE CATALOG {global_config['catalog']['name']}")
    
    # Create schemas for medallion architecture
    for schema_name, schema_config in global_config['schemas'].items():
        spark.sql(f"""
            CREATE SCHEMA IF NOT EXISTS {schema_name}
            COMMENT 'DfE education data - {schema_name} layer'
        """)
    
    print("✅ Unity Catalog environment initialized successfully!")

# COMMAND ----------

# DBTITLE 1,Data Quality & Validation Functions
class DFEQualityFramework:
    """Data quality framework for DfE education data"""
    
    @staticmethod
    def validate_enrolment_data(df):
        """Validate enrolment data against DfE business rules"""
        
        validation_results = {
            'total_records': df.count(),
            'null_enrolment_ids': df.filter(F.col('enrolment_id').isNull()).count(),
            'null_provider_ids': df.filter(F.col('provider_id').isNull()).count(),
            'duplicate_enrolments': df.count() - df.dropDuplicates(['enrolment_id']).count()
        }
        
        validation_results['quality_score'] = (
            (validation_results['total_records'] - validation_results['null_enrolment_ids'] - 
             validation_results['duplicate_enrolments']) / validation_results['total_records']
        ) * 100
        
        return validation_results

# COMMAND ----------

# DBTITLE 1,Initialize the Environment
# Initialize UC and schemas
initialize_uc_environment()

# Set current schema to bronze
spark.sql(f"USE SCHEMA {global_config['schemas']['bronze']['name']}")

print("🎓 DfE Education Lakehouse initialized and ready for pipeline execution!")
print("Next: Run 1_bronze_ingest notebook to start data processing.")
