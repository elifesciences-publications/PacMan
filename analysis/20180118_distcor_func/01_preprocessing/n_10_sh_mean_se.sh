#!/bin/sh


###############################################################################
# Create mean undistorted SE EPI image.                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define session IDs & paths:

# Input file:
strPthIn="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/nii_distcor/func_reg_distcorUnwrp/func_00.nii.gz"

# Ouput file:
strPthOut="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/nii_distcor/func_reg_tsnr/se_epi_mean"
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Calculate mean image

fslmaths ${strPthIn} -Tmean ${strPthOut}
# -----------------------------------------------------------------------------
