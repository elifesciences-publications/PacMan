#!/bin/sh


################################################################################
# The purpose of this script is to copy and rename statistical maps.           #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

strPathParent01="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171213/nii_distcor/feat_level_2_trans/"

# Functional runs (input & output):
lstIn=(feat_level_2_Control_Dynamic \
       feat_level_2_PacMan_Dynamic \
       feat_level_2_PacMan_Dynamic_minus_Control_Dynamic \
       feat_level_2_PacMan_Static \
       feat_level_2_PacMan_Dynamic_minus_PacMan_Static)

strPathParent02=".gfeat/cope1.feat/stats/zstat1.nii.gz"

strPathOutput="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171213/nii_distcor/stat_maps_trans/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Copy and rename statistical maps:

echo "---Copy and rename statistical maps---"
date

for index01 in ${lstIn[@]}
do

	strTmpIn="${strPathParent01}${index01}${strPathParent02}"
	strTmpOut="${strPathOutput}${index01}_zstat1.nii.gz"
	echo "------cp ${strTmpIn} ${strTmpOut}"
	cp ${strTmpIn} ${strTmpOut}

done

date
echo "done"
#-------------------------------------------------------------------------------
