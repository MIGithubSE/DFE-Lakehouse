# Scripts\Documentation-Generators.ps1 - COMPLETE VERSION

function Get-ReadmeContent {
    return @"
# DfE Education Lakehouse Pipeline

A comprehensive Databricks medallion architecture pipeline for Department for Education (DfE) data processing, built with Unity Catalog and Delta Lake.

## 🎯 Project Overview

This project implements a production-ready data pipeline for processing education enrolment and provider data, following DfE data standards and best practices.

## 📁 Project Structure

\`\`\`
education-lakehouse-pipeline/
├── README.md
├── config/
│   ├── global_config.json
│   └── secrets_example.json
├── notebooks/
│   ├── 0_utils_and_setup.py
│   ├── 1_bronze_ingest.py
│   ├── 2_silver_transform.py
│   ├── 3_gold_aggregate.py
│   ├── 4_data_quality_checks.py
│   └── 5_visualise_plotly.py
├── sql/
│   ├── create_uc_catalogs.sql
│   └── gold_dashboard_queries.sql
├── tests/
│   ├── unit_tests_pyspark.py
│   └── dq_rules.json
├── jobs/
│   └── databricks_job_spec.json
└── docs/
    └── architecture.md
\`\`\`

## 🏗️ Architecture

### Medallion Architecture
- **Bronze**: Raw data ingestion with schema enforcement
- **Silver**: Data cleansing, validation, and enrichment
- **Gold**: Business-level aggregates for policy dashboards

### Key Features
- Unity Catalog integration for governance
- DfE-specific data quality framework
- Automated data lineage and audit trails
- Policy-ready aggregates and visualizations

## 🚀 Quick Start

### Prerequisites
- Databricks workspace with Unity Catalog enabled
- Databricks CLI configured
- Appropriate cluster permissions

### Deployment
1. Update configuration in \`config/global_config.json\`
2. Set Databricks token: \`\$env:DATABRICKS_TOKEN = "your-token"\`
3. Run deployment: \`.\Scripts\Deploy-To-Databricks.ps1\`

### Manual Execution
\`\`\`python
# Run in Databricks workspace
%run ./notebooks/0_utils_and_setup
%run ./notebooks/1_bronze_ingest  
%run ./notebooks/2_silver_transform
%run ./notebooks/3_gold_aggregate
\`\`\`

## 📊 Data Sources

- **Enrolments**: Student enrolment records with programme details
- **Providers**: Education provider information and Ofsted ratings

## 🔧 Configuration

Update \`config/global_config.json\` with your environment specifics:
- Unity Catalog names and paths
- Data source locations
- Email notifications
- Schedule configurations

## 🧪 Testing

Run data quality tests:
\`\`\`python
%run ./tests/unit_tests_pyspark
\`\`\`

## 📈 Monitoring

- Data quality scores tracked in audit tables
- Pipeline performance metrics
- Alerting for data quality issues

## 👥 Team

- Data Engineering: Data pipeline development
- Policy Analysts: Gold layer consumption
- Data Governance: Unity Catalog management

## 📄 License

This project is for DfE internal use.
"@
}

function Get-ArchitectureContent {
    return @"
# DfE Education Lakehouse Architecture

## Overview

This document describes the architecture of the DfE Education Lakehouse pipeline built on Databricks with Unity Catalog.

## Architecture Diagram

\`\`\`
[Source Systems] → [Bronze Layer] → [Silver Layer] → [Gold Layer] → [Dashboards]
       ↓                ↓               ↓               ↓              ↓
   Raw Data         Validated       Enriched       Aggregated     Policy Views
                  (DfE Standards)  (Business      (KPIs & Metrics)
                                   Logic Applied)
\`\`\`

## Components

### 1. Unity Catalog Structure
\`\`\`
dfe_education/
├── bronze/
│   ├── enrolment_data
│   └── provider_data
├── silver/
│   ├── cleansed_enrolments
│   └── cleansed_providers
└── gold/
    ├── provider_performance
    ├── regional_benchmarks
    └── programme_effectiveness
\`\`\`

### 2. Medallion Layers

#### Bronze Layer
- Raw data ingestion
- Schema validation
- Audit trail creation
- Source system tracking

#### Silver Layer
- Data cleansing and standardization
- DfE business logic application
- Data quality scoring
- Deduplication

#### Gold Layer
- Provider performance metrics
- Regional benchmarks
- Programme effectiveness analysis
- Policy dashboard aggregates

### 3. Data Quality Framework

- Completeness checks
- Validity rules
- Uniqueness validation
- Business rule enforcement

### 4. Security & Governance

- Unity Catalog access controls
- Row-level security
- Data lineage tracking
- Audit logging

## Technology Stack

- **Databricks**: Unified analytics platform
- **Unity Catalog**: Governance and security
- **Delta Lake**: Reliable data storage
- **PySpark**: Data processing
- **Plotly**: Visualization
"@
}
