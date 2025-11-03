# DFE Education Lakehouse - Project Structure

## Folder Structure

\\\
DFE-Lakehouse/
├── notebooks/          # Databricks notebooks
├── sample_data/        # Sample data sources  
├── data/               # Data storage
├── config/             # Configuration files
├── Scripts/            # Automation scripts
├── sql/                # SQL scripts
├── tests/              # Testing framework
├── docs/               # Documentation
├── jobs/               # Job definitions
├── src/                # Source code
├── environment/        # Environment setup
└── logs/               # Log files
\\\

## Architecture Layers

- **Bronze**: Raw data ingestion (\
otebooks/1_bronze_ingest\)
- **Silver**: Data cleaning & validation (\
otebooks/2_silver_transform\)  
- **Gold**: Business aggregates (\
otebooks/3_gold_aggregate\)
- **Quality**: Data quality checks (\
otebooks/4_data_quality_checks\)
- **Visualization**: Analytics & reporting (\
otebooks/5_visualise_plotly\)
