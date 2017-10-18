#!/bin/sh


################################################################################
# The purpose of this script is to reorient images from the Parametric         #
# Contrast Experiment to standard orientation. Afterwards, the original images #
# are removed and replaced by the reoriented ones.                             #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory:
str_path_parent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs (input):
ary_session_IDs_1=(func_01 \
                   func_02 \
                   func_03 \
                   func_04 \
                   func_05 \
                   func_06 \
                   func_07 \
                   func_08 \
                   func_09 \
                   func_10)

# Input path:
str_path_input="${str_path_parent}func_op/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Reorient functional runs:

echo "------------Reorient functional runs:-------------"
date

for index_1 in ${ary_session_IDs_1[@]}
do
	echo "------------------------------------------------"

	str_tmp_1="${str_path_input}${index_1}"
	str_tmp_2="${str_tmp_1}_reor"

	echo "---fslreorient2std on: ${str_tmp_1}"
	echo "---------------output: ${str_tmp_2}"

	echo "---fslreorient2std ${str_tmp_1} ${str_tmp_2}"
	fslreorient2std ${str_tmp_1} ${str_tmp_2}

	echo "---rm ${str_tmp_1}.nii.gz"
	rm "${str_tmp_1}.nii.gz"

	echo "---mv ${str_tmp_2}.nii.gz ${str_tmp_1}.nii.gz"
	mv "${str_tmp_2}.nii.gz" "${str_tmp_1}.nii.gz"

	echo "------------------------------------------------"
done
#-------------------------------------------------------------------------------


