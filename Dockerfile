FROM tensorflow/tensorflow:latest-gpu
MAINTAINER Blaine Rister <blaine@stanford.edu>
RUN apt-get update && apt-get install -y git build-essential cmake
WORKDIR /home/python
ADD REQUIREMENTS.txt .
RUN pip install -r REQUIREMENTS.txt
WORKDIR /home/
RUN git clone -b master --single-branch https://github.com/bbrister/cudaImageWarp.git
WORKDIR /home/cudaImageWarp/build
RUN cmake ..
RUN make && make install
RUN pip install -e .
WORKDIR /home/
RUN git clone -b master --single-branch --recurse-submodules https://github.com/bbrister/CTH_seg_inference.git
WORKDIR /home/models
ADD CT_Organ_3mm_extended_Unet_multi.params.pkl .
ADD CT_Organ_3mm_extended_Unet_multi.pb .
WORKDIR /home
ADD run_inference.sh .
ENTRYPOINT ["./run_inference.sh"]
