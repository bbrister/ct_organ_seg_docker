#!/bin/bash

# Usage: ./run_docker_inference.sh [input] [output]
#       [input] and [output] must be files in the 'shared' subdirectory

# Image name
IMAGE=organ_seg

# Arguments
INFILE=$1
OUTFILE=$2

# Paths
SCRIPTDIR=`pwd`
HOME=/home
HOST_SHARED=$SCRIPTDIR/shared
CONTAINER_SHARED=/home/shared

# Build the container
sudo docker build -t $IMAGE .

# Run and put the input into a docker volume
sudo docker run -v $HOST_SHARED:$CONTAINER_SHARED --entrypoint "ls" -t $IMAGE
sudo docker run -v $HOST_SHARED:$CONTAINER_SHARED -t $IMAGE $INFILE $OUTFILE