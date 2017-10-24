#!/bin/sh


################################################################################
# The purpose of this script is to perform distortion correction on opposite   #
# phase-encoding data. The input data need to be motion-corrected beforehands. #
# You may use a modified topup configuration file for better results.          #
################################################################################


echo "-Distortion correction"


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory"
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171023/nii_distcor/"

# Functional runs (input & output):
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

# Path for 'datain' text file with acquisition parameters for applytopup (see
# TOPUP documentation for details):
strDatain02="/home/john/PhD/Analysis_Scripts/Analysis_Scripts_344_06012017/Miscellaneous/PacMan/20171023_distcor_func/01_preprocessing/n_09b_datain_applytopup.txt"

# Parallelisation factor:
varPar=4

# Path of images to be undistorted (input):
strPathFunc="${strPathParent}func_regWithinRun/"

# Path for bias field (input):
strPathRes01="${strPathParent}func_distcorField/"

# Path for undistorted images (output):
strPathRes02="${strPathParent}func_distcorUnwrp/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Preparations

echo "---Preparations"

# Number of runs:
varNumRun=${#aryRun[@]}
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Apply distortion correction:

echo "---Apply distortion correction"
date

# Parallelisation over runs:
for idxRun in $(seq 0 $((${varNumRun} - 1)))
do

	#echo "------Run: ${aryRun[idxRun]}" &

	applytopup \
	--imain=${strPathFunc}${aryRun[idxRun]} \
	--datain=${strDatain02} \
	--inindex=1 \
	--topup=${strPathRes01}${aryRun[idxRun]} \
	--out=${strPathRes02}${aryRun[idxRun]} \
	--method=jac &

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
#-------------------------------------------------------------------------------


