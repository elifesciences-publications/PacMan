#!/bin/sh


################################################################################
# The purpose of this script is to copy and rename statistical maps.           #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

strPathParent01="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/feat_level_1/"

# Functional runs (input & output):
lstIn=(func_01 \
       func_02 \
       func_03 \
       func_04 \
       func_05 \
       func_06)

strPathParent02=".feat/stats/pe1.nii.gz"

strPathOutput="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/stat_maps_single_run/feat_level_1_PacMan_Dynamic_"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Copy and rename statistical maps:

echo "---Copy and rename statistical maps---"
date

for index01 in ${lstIn[@]}
do

	strTmpIn="${strPathParent01}${index01}${strPathParent02}"
	strTmpOut="${strPathOutput}${index01}_pe1.nii.gz"
	echo "------cp ${strTmpIn} ${strTmpOut}"
	cp ${strTmpIn} ${strTmpOut}

done

date
echo "done"
#-------------------------------------------------------------------------------
