# world-cup-qatar-elt-dbt

This repo shows a real world use case with DBT, BigQuery and Google Cloud. 
The raw and input data are represented by the Qatar Fifa World Cup Players stats, 
some transformations are applied with the ELT pattern and DBT to apply aggregation and business transformations.

![dbt_elt_cloud_run_job.png](diagram%2Fdbt_elt_cloud_run_job.png)

## Build the Docker image locally 

```bash
docker build 
```

## Run the Docker image locally

```bash
docker run -it \
    -e GOOGLE_PROJECT=$PROJECT_ID \
    -e GOOGLE_REGION=$LOCATION \
    -e IAC_BACKEND_URL=$IAC_BACKEND_URL \
    -e TABLES_CONFIG_FILE="$TABLES_CONFIG_FILE_PATH" \
    -e ROOT_TEST_FOLDER=$ROOT_TEST_FOLDER \
    -e ROOT_TABLES_FOLDER="$ROOT_TABLES_FOLDER" \
    -v $(pwd)/examples/tests:/opt/bigtesty/tests \
    -v $(pwd)/examples/tests/tables:/opt/bigtesty/tests/tables \
    -v $HOME/.config/gcloud:/opt/bigtesty/.config/gcloud \
    groupbees/bigtesty test
```

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-dbt-app-cloud-run-job.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT" \
    --verbosity="debug" .
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