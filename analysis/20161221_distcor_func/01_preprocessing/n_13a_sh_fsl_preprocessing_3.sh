#!/bin/sh


################################################################################
# The purpose of this script is to crop functional time series  around a       #
# region of interest. This is done because it is unnecessary to fit the GLM to #
# the entire dataset.                                                          #
################################################################################
# Note: Just multiplying the time series with a binary mask seems not to speed #
# up the feat analysis - although this seems unlikely, it may be that feat     #
# does not ignore zero voxels when fitting the GLM. Therefore, the images need #
# to be cropped instead of multiplying them with the binary mask. This has the #
# disadvantage that the results cannot be displayed on the whole brain image   #
# anymore. The line which performs the cropping needs to be commented out if   #
# results are to be displayed on a whole brain image.                          #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs (input & output):
arySessionIDs=(func_01 \
               func_02 \
               func_03 \
               func_04 \
               func_05 \
               func_06 \
               func_07 \
               func_08 \
               func_09 \
               func_10)

# Input directory:
strPathInput="${strPathParent}func_regAcrssRuns/"

# 'Points4crop', i.e. binary mask with points at the maximum and minimum image
# dimensions in x, y, and z direction after cropping:
strPathMask="${strPathParent}evc_cubes/for_feat/20161221_func_mean_points4crop"

# Output directory:
strPathOutput="${strPathParent}func_regAcrssRuns_cube/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Crop functional time series:

echo "----------------------Crop functional time series:-----------------------"
date

for index01 in ${arySessionIDs[@]}
do
	strTmp01="${strPathInput}${index01}"
	strTmp02="${strPathOutput}${index01}"
	echo "---crop image: ${strTmp01}"
	echo "-------output: ${strTmp02}"

	# Option 1: Multiply 4D image with binary mask:
	#echo "---fslmaths ${strTmp01} -mul ${strPathMask} ${strTmp02}"
	#fslmaths ${strTmp01} -mul ${strPathMask} ${strTmp02}

	# Option 2: Crop 4D image:
	# Get coordinates [x y z t] of non-zero voxels in mask
	strTmp03=`fslstats ${strPathMask} -w`
	# Remove last characters (representing the time dimension)
	strTmp03=${strTmp03::-4}
	# Add new time dimension (first to last volume)
	strTmp03="${strTmp03}0 -1"
	echo "---fslroi ${strTmp01} ${strTmp02} ${strTmp03}"
	fslroi ${strTmp01} ${strTmp02} ${strTmp03}
done

date
echo "done"
#-------------------------------------------------------------------------------


