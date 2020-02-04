#!/bin/bash

#Usage: run_inference.sh [input file] [output volume] [output labels]

echo "Container received input path $1"
echo "Container received output volume path $2"
echo "Container received output labels path $3"

MODELDIR=models
PB_PATH=$MODELDIR/model.pb
PARAMS_PATH=$MODELDIR/params.pkl
PROG="python -B"
SCRIPT=run_inference_imutil.py
RESOLUTION=3

INDIR=/envoyai/input
OUTDIR=/envoyai/output
INFILE=$INDIR/$1
OUTVOLUMEFILE=$OUTDIR/$2
OUTLABELSFILE=$OUTDIR/$3

$PROG $SCRIPT $PB_PATH $PARAMS_PATH $INFILE $OUTLABELSFILE $OUTVOLUMEFILE $RESOLUTION
