# Project: world-cup-qatar-elt-dbt

ELT pipeline with dbt, BigQuery and Google Cloud.
Raw data: Qatar FIFA World Cup Players stats.
Transformations: aggregation and business logic via dbt.

## Tech stack

- **dbt** (dbt-core + dbt-bigquery) for data transformations
- **BigQuery** as data warehouse
- **Apache Airflow** for orchestration
- **Cloud Run Jobs** for deployment
- **Cloud Build** for CI/CD
- **uv** as Python package manager
- **direnv** with `.envrc` for environment management

## Project structure

- `dbt/` - dbt project (models, seeds, macros, profiles)
- `world_cup_qatar_elt_dbt_dag/` - Airflow DAG
- `deploy-dbt-app-cloud-run-job.yaml` - Cloud Build config
- `Dockerfile` - dbt-bigquery based Docker image for Cloud Run Job

## Development setup

- Python 3.13.11 (see `.python-version`)
- Uses `uv` for dependency management (`pyproject.toml`)
- Uses `direnv` with `.envrc` for automatic venv activation and env vars
- Run `uv sync` to install dependencies
- GCP project: `gb-poc-373711`, region: `europe-west1`

## dbt commands

```bash
dbt deps --profiles-dir dbt --project-dir dbt
dbt seed --profiles-dir dbt --project-dir dbt
dbt run --profiles-dir dbt --project-dir dbt
```
