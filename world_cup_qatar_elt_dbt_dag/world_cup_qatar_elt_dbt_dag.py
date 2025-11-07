import os
from datetime import datetime

from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.empty import EmptyOperator

default_args = {
    "owner": "airflow",
    "start_date": datetime(2025, 1, 1),
    "retries": 0,
}

DBT_PROJECT_DIR = os.environ.get(
    "DBT_PROJECT_DIR",
    "/opt/airflow/dags/world_cup_qatar_elt_dbt_project"
)

with DAG(
        dag_id="world_cup_qatar_elt_dbt_dag",
        default_args=default_args,
        schedule=None,
        catchup=False,
        description="World Cup ELT pipeline using dbt"
) as dag:
    start = EmptyOperator(task_id="start")

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=f"""
        set -e
        echo "📦 Installing dbt dependencies..."
        dbt deps --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROJECT_DIR}
        """,
        append_env=True,
    )

    dbt_seed = BashOperator(
        task_id="dbt_seed",
        bash_command=f"""
        set -e
        echo "🌱 Running dbt seed..."
        dbt seed --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROJECT_DIR}
        """,
        append_env=True,
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"""
        set -e
        echo "🚀 Running dbt models..."
        dbt run --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROJECT_DIR} --fail-fast
        """,
        append_env=True,
    )

    end = EmptyOperator(task_id="end")

    start >> dbt_deps >> dbt_seed >> dbt_run >> end
