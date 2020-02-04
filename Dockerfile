FROM tensorflow/tensorflow:latest-gpu

MAINTAINER Blaine Rister <blaine@stanford.edu>

# Compilers, SIFT3D dependencies
RUN apt-get update && apt-get install -y git build-essential cmake dcmtk zlib1g-dev liblapack-dev libdcmtk-dev libnifti-dev

# Install Python dependencies
WORKDIR /home/python
ADD REQUIREMENTS.txt .
RUN pip install -r REQUIREMENTS.txt

# Install SIFT3D
WORKDIR /home/
RUN git clone -b python --single-branch https://github.com/bbrister/SIFT3D.git
WORKDIR /home/SIFT3D/build
RUN cmake ..
RUN make && make install
WORKDIR /home/SIFT3D/wrappers/python
RUN pip install -e .

# Install CudaImageWarp
WORKDIR /home/
RUN git clone -b master --single-branch https://github.com/bbrister/cudaImageWarp.git
WORKDIR /home/cudaImageWarp/build
RUN cmake ..
RUN make && make install
RUN pip install -e .
WORKDIR /home/

# Install CTH_seg_inference
RUN git clone -b master --single-branch --recurse-submodules https://github.com/bbrister/CTH_seg_inference.git
WORKDIR /home/models
ADD params.pkl .
ADD model.pb .
WORKDIR /home

# Install the docker entrypoint scripts
ADD run_inference_imutil.py .
ADD run_inference.sh .
ENTRYPOINT ["./run_inference.sh", "dicom-series-in", "volume.nii", "labels.nii"]

#------------------------- EnvoyAI stuff ---------------------------

# EnvoyAI input DICOM
LABEL com.envoyai.metadata-version=2
LABEL com.envoyai.schema-in="\
dicom-series-in:\n\
  dicom-type: dicom-series"

# EnvoyAI output Niftis
LABEL com.envoyai.schema-out="\
volume.nii:\n\
  mime-type: application/octet-stream\n\
labels.nii:\n\
  mime-type: application/octet-stream"

# EnvoyAI display of input volume
LABEL com.envoyai.display="\
source-display-group:\n\
  display-elements:\n\
    - title: Input DICOM\n\
      id: input-dicom\n\
      content:\n\
        pointer:\n\
          source: input\n\
          property: dicom-series-in\n"

# EnvoyAI container labels
LABEL com.envoyai.info="\
name: Organ Segmenter\n\
title: Organ segmentation model for evaluation purposes\n\
author: Blaine Rister\n\
organization: Stanford University"
