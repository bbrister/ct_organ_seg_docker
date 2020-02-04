#!/bin/bash

#Usage: run_inference.sh [input file] [output file]

echo "Container received input path $1"
echo "Container received output path $2"

MODELDIR=models
PB_PATH=$MODELDIR/model.pb
PARAMS_PATH=$MODELDIR/params.pkl
PROG="python -B"
SCRIPT=run_inference_imutil.py
RESOLUTION=3

SHARED=/home/shared
INFILE=$SHARED/$1
OUTFILE=$SHARED/$2
INCOPYFILE="$INFILE-COPY.nii"

$PROG $SCRIPT $PB_PATH $PARAMS_PATH $INFILE $OUTFILE $INCOPYFILE $RESOLUTION
