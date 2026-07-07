#!/bin/bash

desired_jobs=(
  "spacewise-postgres"
  "spacewise-mongo"
  "spacewise-redis"
  "spacewise-redis-populate"
  "spacewise-rabbitmq"
  "spacewise-backend"
  "spacewise-celery"
  "spacewise-flower"
  "spacewise-face"
  "spacewise-fixture"
  "spacewise-node"
  "spacewise-minio"
  "spacewise-populate-descriptor-mongo"
  "spacewise-scrape-spacetrack"
)

job_file_path="./Jobs"

export NOMAD_ADDR=http://127.0.0.1:4646

# Get the list of running jobs
running_jobs=$(nomad status)

# Get the list of all jobs (including stopped/purged ones)
all_jobs=$(nomad job status -short)

# Classify jobs into categories
batch_jobs=("spacewise-fixture")
cron_jobs=("spacewise-populate-descriptor-mongo" "spacewise-redis-populate" "spacewise-scrape-spacetrack")
services=("spacewise-postgres" "spacewise-mongo" "spacewise-redis" "spacewise-rabbitmq" "spacewise-flower" "spacewise-minio")
projects=("spacewise-backend" "spacewise-face" "spacewise-node" "spacewise-celery")

# Ask user for confirmation to deploy each category of jobs
read -p "Do you want to deploy batch jobs? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  deploy_batch=true
else
  deploy_batch=false
fi

read -p "Do you want to deploy cron jobs? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  deploy_cron=true
else
  deploy_cron=false
fi

read -p "Do you want to deploy services? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  deploy_services=true
else
  deploy_services=false
fi

read -p "Do you want to deploy projects? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  deploy_projects=true
else
  deploy_projects=false
fi

# Deploy jobs based on user input
for job in "${desired_jobs[@]}"; do
  job_file="$job_file_path/$job.nomad"

  # Check if the Job file is present
  if [ ! -f "$job_file" ]; then
    echo "Error: Job file $job_file not found."
    continue
  fi

  # Check if the job is already running
  if ! echo "$running_jobs" | grep -q "$job"; then
    # Check if the job is stopped or purged
    if ! echo "$all_jobs" | grep -q "$job"; then
      # Job is not running and not present in the list of all jobs, so deploy it
      if [[ " ${batch_jobs[*]} " =~ " $job " ]] && [ "$deploy_batch" == "true" ]; then
        nomad run "$job_file"
      elif [[ " ${cron_jobs[*]} " =~ " $job " ]] && [ "$deploy_cron" == "true" ]; then
        nomad run "$job_file"
      elif [[ " ${services[*]} " =~ " $job " ]] && [ "$deploy_services" == "true" ]; then
        nomad run "$job_file"
      elif [[ " ${projects[*]} " =~ " $job " ]] && [ "$deploy_projects" == "true" ]; then
        nomad run "$job_file"
      fi
    else
      # Job is stopped or purged, so start it
      nomad start "$job"
    fi
  fi
done