#!/bin/sh


################################################################################
# The purpose of this script is to create approximate brain masks to be used   #
# for SPM motion correction, in the initial within-run motion correction. Each #
# run gets its own brain mask, because moco is initially applied within runs,  #
# before distortion correction.                                                #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory:
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs (input):
aryRun=(func_01 \
        func_02 \
        func_03 \
        func_04 \
        func_05 \
        func_06 \
        func_07 \
        func_08 \
        func_09 \
        func_10)

# SPM directory:
strPathSpmParent="${strPathParent}spm_regWithinRun_op/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Create brain masks:

echo "------Create brain masks:------"
date

for idx01 in ${aryRun[@]}
do
	echo "---Processing: ${idx01}"

	# Input file name:
	strTmp01="${strPathSpmParent}${idx01}/${idx01}"

	# Name for first volume (used for brain extraction):
	strTmp02="${strPathSpmParent}${idx01}_ref_weighting/${idx01}_vol_1"

	# Get first volume:
	fslroi ${strTmp01} ${strTmp02} 0 1

	# Output file name for brain mask (bet automatically appends
	# '_mask.nii.gz'):
	strTmp03="${strPathSpmParent}${idx01}_ref_weighting/${idx01}"

	# Brain extraction:
	bet ${strTmp02} ${strTmp03} -f 0.2 -g 0 -n -m

	# Change filetype of brain mask (SPM requires *.nii, not *.nii.gz):
	fslchfiletype NIFTI ${strTmp03}_mask ${strTmp03}_brainmask

	# Remove first volume & compressed brain mask:
	rm "${strTmp02}.nii.gz"
	rm "${strTmp03}_mask.nii.gz"
done

date
echo "done"
#-------------------------------------------------------------------------------
