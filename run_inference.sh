#!/bin/bash

#Usage: run_inference.sh [input file] [output file]

echo "Container received input path $1"
echo "Container received output path $2"

MODELDIR=models
PB_PATH=$MODELDIR/CT_Organ_3mm_extended_Unet_multi.pb
PARAMS_PATH=$MODELDIR/CT_Organ_3mm_extended_Unet_multi.params.pkl
CTH_PATH=CTH_seg_inference
PROG="python -B"
SCRIPT=$CTH_PATH/inference.py
RESOLUTION=3

SHARED=/home/shared
INFILE=$SHARED/$1
OUTFILE=$SHARED/$2

$PROG $SCRIPT $PB_PATH $PARAMS_PATH $INFILE $OUTFILE $RESOLUTION
