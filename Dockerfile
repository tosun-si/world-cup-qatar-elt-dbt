FROM ghcr.io/dbt-labs/dbt-bigquery:1.8.2

WORKDIR /app/dbt

COPY dbt/packages.yml ./
COPY dbt/dbt_project.yml ./

RUN dbt deps --profiles-dir . --project-dir .

COPY dbt/ ./

ENTRYPOINT ["/bin/bash", "-c", "\
    set -e && \
    echo '🌱 Running dbt seed...' && \
    dbt seed --profiles-dir . --project-dir . && \
    echo '🚀 Running dbt run...' && \
    dbt run --profiles-dir . --project-dir . \
"]
