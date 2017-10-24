#!/bin/sh


################################################################################
# The purpose of this script is to preprocess the data of the Parametric       #
# Contrast Experiment after they have been distortion corrected. The following #
# steps are performed in this script:                                          #
#   - Discard upper & lower slices of functional data                          #
#   - Copy resulting files into SPM directory tree                             #
#   - Remove input files                                                       #
# Motion correction and registrations are performed with SPM afterwards.       #
################################################################################
# IMPORTANT: Adjust fslroi command according to number of slices.              #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory:
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171023/nii_distcor/"

# Functional runs (input):
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
strPathInput="${strPathParent}func_distcorUnwrp/"

# Output directory (after discarding slices):
strPathOutput="${strPathParent}func_roi/"

# SPM directory:
strPathSpmParent="${strPathParent}spm_regAcrssRuns/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Discard upper & lower slices of functional data:

echo "------------Discard upper & lower slices of functional data:-------------"
date

for index01 in ${arySessionIDs[@]}
do
     strTmp01="${strPathInput}${index01}"
     strTmp02="${strPathOutput}${index01}"

     echo "---fslroi on: ${strTmp01}"
     echo "------output: ${strTmp02}"
     echo "fslroi ${strTmp01} ${strTmp02} 0 -1 3 -1 0 -1 0 -1"
     fslroi ${strTmp01} ${strTmp02} 0 -1 3 -1 0 -1 0 -1

     # Remove input func:
     echo "---rm ${strTmp01}.nii.gz"
     rm "${strTmp01}.nii.gz"
done

date
echo "done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Change filetype and save resulting nii file to SPM directory:

# SPM requires *.nii files as input, not *.nii.gz.

echo "------Change filetype and save resulting nii file to SPM directory:------"
date

for index01 in ${arySessionIDs[@]}
do
     strTmp01="${strPathOutput}${index01}"
     strTmp02="${strPathSpmParent}${index01}/${index01}"

     echo "---fslchfiletype on: ${strTmp01}"
     echo "-------------output: ${strTmp02}"
     echo "---fslchfiletype NIFTI ${strTmp01} ${strTmp02}"
     fslchfiletype NIFTI ${strTmp01} ${strTmp02}

     # Remove func_roi:
     echo "---rm ${strTmp01}.nii.gz"
     rm "${strTmp01}.nii.gz"
done

date
echo "done"
#-------------------------------------------------------------------------------


