#!/bin/sh


################################################################################
# The purpose of this script is to copy the mean & tSNR images.                #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/nii_distcor/func_reg_tsnr/"

# Functional runs (input & output):
lstIn=(combined_mean \
       combined_mean_tSNR)

strPathOutput="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/nii_distcor/stat_maps_trans/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Copy images:

echo "---Copy images---"
date

for index01 in ${lstIn[@]}
do

	strTmpIn="${strPathParent}${index01}.nii.gz"
	strTmpOut="${strPathOutput}${index01}.nii.gz"
	echo "------cp ${strTmpIn} ${strTmpOut}"
	cp ${strTmpIn} ${strTmpOut}

done

date
echo "done"
#-------------------------------------------------------------------------------
