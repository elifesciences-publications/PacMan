#!/bin/sh

################################################################################
# Copy registered images for segmentation.                                     #
################################################################################

echo "-Copy registered images for segmentation"

cp \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/mp2rage/03_reg/07_reg/04_inv_bbr/*.nii.gz \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/mp2rage/04_seg/01_native_space/

cp \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_regAcrssRuns_cube_tSNR/combined_mean.nii.gz \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/mp2rage/04_seg/01_native_space
