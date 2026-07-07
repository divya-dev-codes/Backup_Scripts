#!/bin/bash

artifacts=(
    "docker-images"
    "Jobs"
    "Variables"
    "cron_jobs.sh"
    "deleted_docker_images.sh"
    "deleted_jobs.sh"
    "deploy_jobs.sh" 
    "deploy_services.sh"
    "docker_images.sh"
    "nomad.hcl"
    "nomad.services"
    "nomad_1.7.7_linux_amd64.zip"
    "nomad_install.sh"
    "nomad_variables.sh"
    "setup_service.sh"
)

function check_artifact {
    local artifact=$1
    if find . -name "$artifact" -print -quit | grep -q '^'; then
        return 0
    else
        return 1
    fi
}

all_present=true
for artifact in "${artifacts[@]}"; do
    if check_artifact "$artifact"; then
        continue
    else
        echo "$artifact is missing."
        all_present=false
    fi
done

if $all_present; then
    echo "Success: All artifacts are present."
fi