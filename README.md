# world-cup-qatar-elt-dbt

This repo shows a real world use case with DBT, BigQuery and Google Cloud. 
The raw and input data are represented by the Qatar Fifa World Cup Players stats, 
some transformations are applied with the ELT pattern and DBT to apply aggregation and business transformations.

![dbt_elt_cloud_run_job.png](diagram%2Fdbt_elt_cloud_run_job.png)

## Publish the Docker image to Artifact Registry and deploy the Cloud Run job with Cloud Build

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-dbt-app-cloud-run-job.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT" \
    --verbosity="debug" .
```