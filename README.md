INFORMATION

This repo is for running a pre-trained model for CT organ segmentation.

This repo builds the Docker image, but it currently lacks some of the larger binary files. Those are in the prebuilt container which is on [DockerHub](https://hub.docker.com/repository/docker/bbrister/organ_seg).

INSTALLATION

Simply download or clone this repository. The scripts will automatically clone the Docker container when they're first used.

USAGE

Steps to run inference:

        1. Put the input image in the 'shared' subdirectory. This can be either a Nifti file (.nii, .nii.gz), a Dicom file (.dcm) or a direcotry of Dicom files

        3. Run inference with:
                ./run_docker_container [input_name] [output_name]

Omit the path to 'shared' in input_name and output_name. Those are implied.

EXAMPLE

For example, if your data is in the directory 'shared/dicom', then run:

        ./run_docker_container dicom labels.nii

When it's finished, you should have:
        - shared/labels.nii (the segmentation)
        - shared/dicom-COPY.nii (for visualization)
       
