#!/usr/bin/env bash

echo "Starting temporary docker container. No changes to container will be saved!"

# Run Temporary Docker Container
docker run --rm -d -p 8787:8787 -v $(pwd):/home/rstudio -e DISABLE_AUTH=true turdus_analyses_container:latest
