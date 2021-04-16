#!/usr/bin/env bash
 
# Build docker image using docker buildkit
DOCKER_BUILDKIT=1 docker build -t turdus_analyses_container .
