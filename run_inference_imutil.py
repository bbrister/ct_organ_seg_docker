import sys
import numpy as np

from pySift3D import imutil

# Find the inference module
from CTH_seg_inference import inference

# Usage: same as inference.py, but uses SIFT3D image reader instead of Nibabel.
#
#  Arugments:
# [pb_path] [params_path] [image_path] [nii_out_path] (input_copy_path) (resolution) (class_path)

# Parse the arguments, copied from inference.py...
pb_path = sys.argv[1]
params_path = sys.argv[2]
image_path = sys.argv[3]
nii_out_path = sys.argv[4]
try:
    input_copy_path = sys.argv[5]
except IndexError:
    input_copy_path = None
try:
    resolution = float(sys.argv[6]) # Resample to this resolution
except IndexError:
    resolution = None # No resampling
try:
    class_idx = sys.argv[7] # In [0, ..., num_class - 1]. Otherwise returns argmax
except IndexError:
    class_idx = None

# Read the image
im, units = imutil.im_read(image_path)

# Ensure the image is single-channel
channelAxis = 3
if len(im.shape) >= channelAxis + 1 and im.shape[channelAxis] is not 1:
        raise ValueError("Received %d input channels, only one allowed!" % (
                im.shape[channelAxis]))

# Strip the extra channel
im = np.squeeze(im, axis=channelAxis)

# Run inference
inference.inference_main_with_image(pb_path, params_path, im, units, nii_out_path,
        resolution=resolution,
        class_idx=class_idx)

print ("Wrote output to %s" % nii_out_path)

# Optionally copy the input
if input_copy_path is not None:
        import nibabel as nib
        nii = nib.Nifti1Image(im, np.eye(4), None)
        nib.save(nii, input_copy_path)
        print ("Wrote input to %s" % input_copy_path)
