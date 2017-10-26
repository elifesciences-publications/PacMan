#!/bin/sh


###############################################################################
# The purpose of this script is to copy input files from SPM bias field       #
# correction.                                                                 #
###############################################################################


#------------------------------------------------------------------------------
# *** Define parameters:

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171023/nii_distcor/"

# Input folder:
strPthIn="mp2rage/01_orig/"

# Output folder:
strPthOut="mp2rage/02_spm_bf_correction/"

# Array of files:
aryIn=(mp2rage_inv1 \
       mp2rage_pdw \
       mp2rage_t1 \
       mp2rage_uni)
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy files

# Loop through files:
for strTmp in ${aryIn[@]}
do
	# Input file:
  strTmpPthIn="${strPthPrnt}${strPthIn}${strTmp}"

  # Output file:
  strTmpPthOut="${strPthPrnt}${strPthOut}${strTmp}"

  # Change file type to nii (uncompressed):
  fslchfiletype NIFTI ${strTmpPthIn} ${strTmpPthOut}
done
#------------------------------------------------------------------------------
