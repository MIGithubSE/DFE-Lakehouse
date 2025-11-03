# Scripts\Config-Generators.ps1

function Get-GlobalConfig {
    return @{
        catalog = @{
            name = "dfe_education"
            managed_location = "s3://dfe-education-data/uc-managed/"
            comment = "DFE Education Data Lakehouse - Unity Catalog"
        }
        schemas = @{
            bronze = @{
                name = "bronze"
                comment = "Raw source data from DfE systems"
            }
            silver = @{
                name = "silver"
                comment = "Cleansed, validated education data"
            }
            gold = @{
                name = "gold"
                comment = "Business-level aggregates for policy dashboards"
            }
        }
        medallion_paths = @{
            bronze = "/mnt/dfe-education/bronze/"
            silver = "/mnt/dfe-education/silver/"
            gold = "/mnt/dfe-education/gold/"
        }
        data_sources = @{
            enrolments = @{
                source_path = "/mnt/raw-data/enrolments/"
                format = "json"
                schema = "enrolments_schema"
            }
            providers = @{
                source_path = "/mnt/raw-data/providers/"
                format = "json"
                schema = "providers_schema"
            }
        }
        pipeline = @{
            schedule = "0 0 6 * * ?"
            timezone = "Europe/London"
            alert_emails = @("data-engineering@education.gov.uk")
        }
    }
}

function Get-SecretsExample {
    return @{
        databricks_token = "dapi1234567890abcdef"
        storage_account_key = "your-storage-account-key"
        database_password = "your-database-password"
    }
}

function Get-JobSpec {
    param([string]$RepoPath, [string]$ClusterId)
    
    return @{
        name = "dfe-education-medallion-pipeline"
        tags = @{
            department = "education"
            team = "data-engineering"
            project = "education-lakehouse"
            environment = "production"
        }
        email_notifications = @{
            on_start = @("dfe-data-engineering@education.gov.uk")
            on_success = @("dfe-data-engineering@education.gov.uk")
            on_failure = @("dfe-data-alerts@education.gov.uk")
        }
        tasks = @(
            @{
                task_key = "setup_environment"
                description = "Initialize Unity Catalog and environment"
                notebook_task = @{
                    notebook_path = "$RepoPath/notebooks/0_utils_and_setup"
                }
                existing_cluster_id = $ClusterId
                timeout_seconds = 1200
            },
            @{
                task_key = "bronze_ingestion"
                description = "Ingest raw data into Bronze layer"
                notebook_task = @{
                    notebook_path = "$RepoPath/notebooks/1_bronze_ingest"
                }
                existing_cluster_id = $ClusterId
                depends_on = @(@{task_key = "setup_environment"})
                timeout_seconds = 1800
            },
            @{
                task_key = "silver_transformation"
                description = "Transform data into Silver layer"
                notebook_task = @{
                    notebook_path = "$RepoPath/notebooks/2_silver_transform"
                }
                existing_cluster_id = $ClusterId
                depends_on = @(@{task_key = "bronze_ingestion"})
                timeout_seconds = 2400
            },
            @{
                task_key = "gold_aggregation"
                description = "Create Gold layer aggregates"
                notebook_task = @{
                    notebook_path = "$RepoPath/notebooks/3_gold_aggregate"
                }
                existing_cluster_id = $ClusterId
                depends_on = @(@{task_key = "silver_transformation"})
                timeout_seconds = 1800
            }
        )
        format = "MULTI_TASK"
        schedule = @{
            quartz_cron_expression = "0 0 6 * * ?"
            timezone_id = "Europe/London"
            pause_status = "UNPAUSED"
        }
        max_concurrent_runs = 1
    }
}
