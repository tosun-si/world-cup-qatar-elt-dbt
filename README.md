# world-cup-qatar-elt-dbt

This repo shows a real world use case with DBT, BigQuery and Google Cloud. 
The raw and input data are represented by the Qatar Fifa World Cup Players stats, 
some transformations are applied with the ELT pattern and DBT to apply aggregation and business transformations.

![dbt_elt_cloud_run_job.png](diagram%2Fdbt_elt_cloud_run_job.png)

## Prerequisites

- Python 3.13.11
- [uv](https://docs.astral.sh/uv/) as Python package manager
- [direnv](https://direnv.net/) for automatic environment management

## Setup

Install dependencies:

```bash
uv sync
```

The `.envrc` file automatically creates and activates a virtual environment via `uv venv` when entering the project directory with direnv.

## Build the Docker image locally 

```bash
docker build .
```

## Publish the Docker image to Artifact Registry and deploy the Cloud Run job with Cloud Build

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-dbt-app-cloud-run-job.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT" \
    --verbosity="debug" .
```

### Deploy the DAG and conf in a local Airflow from Docker

```bash
docker run -it \
    -p 8080:8080 \
    -e GOOGLE_APPLICATION_CREDENTIALS=/root/.config/gcloud/application_default_credentials.json \
    -e GCP_PROJECT=gb-poc-373711 \
    -e DBT_PROJECT_DIR=/opt/airflow/dags/world_cup_qatar_elt_dbt_project \
    -v $HOME/.config/gcloud/application_default_credentials.json:/root/.config/gcloud/application_default_credentials.json \
    -v $(pwd)/world_cup_qatar_elt_dbt_dag:/opt/airflow/dags/world_cup_qatar_elt_dbt_dag \
    -v $(pwd)/dbt:/opt/airflow/dags/world_cup_qatar_elt_dbt_project \
    -v $(pwd)/config:/opt/airflow/config \
    airflow-dev
```

### Run dbt locally

Install dbt packages:

```bash
dbt deps --profiles-dir dbt --project-dir dbt
```

Run seeds:

```bash
dbt seed --profiles-dir dbt --project-dir dbt
```

Run the pipeline:

```bash
dbt run --profiles-dir dbt --project-dir dbt
```

### Run dbt docs

Generate docs:

```bash
dbt docs generate --profiles-dir dbt --project-dir dbt
```

Generate lineage with Colibri (column level lineage):

```bash
colibri generate --manifest dbt/target/manifest.json --catalog dbt/target/catalog.json
```

Run the UI:

```bash
dbt docs serve --profiles-dir dbt --project-dir dbt
```


