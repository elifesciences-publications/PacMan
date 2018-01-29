#!/bin/sh

################################################################################
# Copy registered images for segmentation.                                     #
################################################################################

echo "-Copy registered images for segmentation"

cp \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/03_reg/04_reg/04_inv_bbr/*.nii.gz \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/04_seg/

cp \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/03_reg/01_in/combined_mean.nii.gz \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/04_seg/

cp \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/03_reg/01_in/combined_mean_tSNR.nii.gz \
/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/nii_distcor/mp2rage/04_seg/
