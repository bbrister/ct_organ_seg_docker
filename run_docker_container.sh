#!/bin/bash

# Usage: ./run_docker_inference.sh
#  Inputs/outputs are defined in the Dockerfile

# User name
USER=bbrister

# Repository name
REPO=organ_seg

# Tag name
TAG="version1.2-EnvoyAI"

# Image name
IMAGE=$USER/$REPO:$TAG

# Paths
SCRIPTDIR=`pwd`
HOME=/home
HOST_SHARED=$SCRIPTDIR/shared
CONTAINER_INPUT=/envoyai/input
CONTAINER_OUTPUT=/envoyai/output

# Build the container
sudo docker build -t $IMAGE .

# Run and put the input into a docker volume
sudo docker run -v $HOST_SHARED:$CONTAINER_INPUT -v $HOST_SHARED:$CONTAINER_OUTPUT -t $IMAGE
