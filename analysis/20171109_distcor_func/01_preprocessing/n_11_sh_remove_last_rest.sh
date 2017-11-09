#!/bin/sh


###############################################################################
# In session 20171109, the last rest block of every functional run was        #
# skipped because of a bug. The purpose of this script is to remove the last  #
# 10 volumes corresponding to the last rest block from the timeseries.        #
###############################################################################


#------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory"
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/"

# Functional runs (input & output). NOTE: func_07 is not included because it is
# the pRF mapping run.
aryRun=(func_01 \
        func_02 \
        func_03 \
        func_04 \
        func_05 \
        func_06 \
        func_08 \
        func_09)

# Path of images to be cropped:
strPathFunc="${strPathParent}func_reg_distcorUnwrp/"

# Parallelisation factor:
varPar=5
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Preparations

echo "---Preparations"

# Number of runs:
varNumRun=${#aryRun[@]}
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Crop

echo "-Remove volumes corresponding to missing REST condition"
date

# Parallelisation over runs:
for idxRun in $(seq 0 $((${varNumRun} - 1)))
do

	#echo "------Run: ${aryRun[idxRun]}" &

	fslroi \
	${strPathFunc}${aryRun[idxRun]} \
	${strPathFunc}${aryRun[idxRun]} \
	0 240 &

	# Check whether it's time to issue a wait command (if the modulus of the
	# index and the parallelisation-value is zero):
	if [[ $((${idxRun} + 1))%${varPar} -eq 0 ]]
	then
		# Only issue a wait command if the index is greater than zero (i.e.,
		# not for the first segment):
		if [[ ${idxRun} -gt 0 ]]
		then
			wait
			echo "------Progress: $((${idxRun} + 1)) runs out of" \
				"${varNumRun}"
		fi
	fi
done
wait
date
#------------------------------------------------------------------------------
