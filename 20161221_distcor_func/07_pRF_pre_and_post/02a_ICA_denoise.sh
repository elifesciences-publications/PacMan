#!/bin/sh


################################################################################
# The purpose of this script is to remove noise ICA components from functional #
# data. The noise components can be identified using MELODIC ICA within a FEAT #
# preprocessing analysis, followed by identification of components to be       #
# removed using `01_ICA_noise_identification.py`.                              #
################################################################################


#-------------------------------------------------------------------------------
### Define parameters:

# Parent directory:
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs:
aryRunIDs=(func_07 \
           func_08 \
           func_09 \
           func_10)

# List of components to remove:
aryIcaIds=("7,14,10,2,15,33,21,16,35,13,1,56,18,30,22,36" \
           "11,18,13,25,15,1,5,42,44,33,9,12,14,45,2,52" \
           "10,4,2,7,12,32,16,13,22,11,49,51,50,1,33" \
           "16,2,12,8,24,11,10,14,1,29,13,5,40,15,42")

# Output directory:
strPathOut="${strPathParent}func_regAcrssRuns_cube_denoise/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### ICA noise removal:

echo "-----------------------------------------------------------------"
echo "----------------------- ICA noise removal -----------------------"
echo "-----------------------------------------------------------------"

# Save original path in order to cd back to this path in the end:
strPathOrig=( $(pwd) )

# Check number of files to be processed:
varNumIn=${#aryRunIDs[@]}

# Since indexing starts from zero, we subtract one:
varNumIn=$((varNumIn - 1))

for idxRun in $(seq 0 $varNumIn)
do

	# Feat directory of current run:
	strPathFeat="${strPathParent}feat_level_1/${aryRunIDs[idxRun]}.feat/"

	# Outpur path for current run:
	strPathOutTmp="${strPathOut}${aryRunIDs[idxRun]}"

	# List of components to remove from current run:
	strIcasTmp="${aryIcaIds[idxRun]}"

	echo "---fsl_regfilt on:       ${strPathFeat}"
	echo "---output:               ${strPathOutTmp}"
	echo "---components to remove: \"${strIcasTmp}\""

	# cd into feat directory of current run:
	cd "${strPathFeat}"

	fsl_regfilt \
	-i filtered_func_data \
	-o "${strPathOutTmp}" \
	-d filtered_func_data.ica/melodic_mix \
	-f "\"${strIcasTmp}\""

	echo "-----------------------------------------------------------------"

done

# cd back to original directory:
cd "${strPathOrig}"
#-------------------------------------------------------------------------------
