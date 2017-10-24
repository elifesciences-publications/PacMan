#!/bin/sh


################################################################################
# The purpose of this script is to retrieve images from an SPM registration    #
# and crop the images.                                                         #
################################################################################


#-------------------------------------------------------------------------------
### Define session IDs & paths

# Parent directory:
strParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Subdirectories:
#strSub01="${strParent}mp2rage/03_reg/01_in/"
strSub02="${strParent}mp2rage/03_reg/05_prereg/"
strSub03="${strParent}mp2rage/03_reg/06_crop/"

# Input files:

# Combined mean image:
strCombmean="combined_mean"

# Names of mp2rage image components (without file suffix):
strT1="mp2rage_t1"
strInv2="mp2rage_inv2"
strPdw="mp2rage_pdw"
strT1w="mp2rage_t1w"

# SPM prefix:
strSpm="r"

# SPM directory names:
strSpmDirRef="combined_mean/"
strSpmDirSrc="mp2rage_t1w/"
strSpmDirOtr="mp2rage_other/"

# Image with coordinates for cropping:
strCrop="${strParent}evc_cubes/for_feat/20161221_func_mean_points4crop"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Crop images

echo "--Crop images"
date

# Get coordinates [x y z t] of non-zero voxels in mask:
strTmp01=`fslstats ${strCrop} -w`

# Remove last characters (representing the time dimension):
strTmp01=${strTmp01::-4}

# Add new time dimension (first to last volume):
strTmp01="${strTmp01}0 -1"

# Crop images:
fslroi ${strSub02}${strSpmDirRef}${strCombmean} ${strSub03}${strCombmean} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strT1} ${strSub03}${strT1} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strInv2} ${strSub03}${strInv2} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strPdw} ${strSub03}${strPdw} ${strTmp01} &
fslroi ${strSub02}${strSpmDirSrc}${strSpm}${strT1w} ${strSub03}${strT1w} ${strTmp01} &

wait
date
echo "---Done"
#-------------------------------------------------------------------------------

