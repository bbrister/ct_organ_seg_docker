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
ADD CT_Organ_3mm_extended_Unet_multi.params.pkl .
ADD CT_Organ_3mm_extended_Unet_multi.pb .
WORKDIR /home

# Install the docker entrypoint scripts
ADD run_inference_imutil.py .
ADD run_inference.sh .
ENTRYPOINT ["./run_inference.sh"]
