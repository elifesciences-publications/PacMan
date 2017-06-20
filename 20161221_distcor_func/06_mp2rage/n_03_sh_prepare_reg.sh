#!/bin/sh

################################################################################
# The purpose of this script is to prepare the mp2rage to combined mean        #
# registration pipeline. As a preparation, the mp2rage component images have   #
# to be placed in the first subdirectory (i.e. ".../01_in/"), with the         #
# following file names: mp2rage_t1, mp2rage_inv2, mp2rage_pdw, mp2rage_t1w.    #
# Also, in order for FAST bias field estimation to work, a brain mask needs to #
# be provided.                                                                 #
################################################################################


#-------------------------------------------------------------------------------
### Define session IDs & paths

# Parent directory:
strParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Subdirectories:
strSub01="${strParent}mp2rage/03_reg/01_in/"
strSub02="${strParent}mp2rage/03_reg/02_reorient2std/"
strSub03="${strParent}mp2rage/03_reg/03_brainmask/"
strSub04="${strParent}mp2rage/03_reg/04_biasfieldremoval/"
strSub05="${strParent}mp2rage/03_reg/05_prereg/"

# Combined mean image:
strCombmean="combined_mean"

# Brain mask:
strBrainMsk="mp2rage_pdw_brainmask"

# Names of mp2rage image components (without file suffix):
strT1="mp2rage_t1"
strInv2="mp2rage_inv2"
strPdw="mp2rage_pdw"
strT1w="mp2rage_t1w"

# SPM directory names:
strSpmDirRef="combined_mean/"
strSpmDirOtr="mp2rage_other/"
strSpmDirSrc="mp2rage_t1w/"
#-------------------------------------------------------------------------------


echo "-Registration preparation"


#-------------------------------------------------------------------------------
### Reorient to standard

echo "---Reorient to standard"

# Reorient images:
fslreorient2std ${strSub01}${strT1} ${strSub02}${strT1} &
fslreorient2std ${strSub01}${strInv2} ${strSub02}${strInv2} &
fslreorient2std ${strSub01}${strPdw} ${strSub02}${strPdw} &
fslreorient2std ${strSub01}${strT1w} ${strSub02}${strT1w} &
fslreorient2std ${strSub01}${strBrainMsk} ${strSub02}${strBrainMsk} &

wait
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Brain masking

echo "------Apply brain mask"

# Brain masking T1 image:
fslmaths \
${strSub02}${strT1} \
-mul \
${strSub02}${strBrainMsk} \
${strSub03}${strT1} &

# Brain masking INV2 image:
fslmaths \
${strSub02}${strInv2} \
-mul \
${strSub02}${strBrainMsk} \
${strSub03}${strInv2} &

# Brain masking PDw image:
fslmaths \
${strSub02}${strPdw} \
-mul \
${strSub02}${strBrainMsk} \
${strSub03}${strPdw} &

# Brain masking T1w image:
fslmaths \
${strSub02}${strT1w} \
-mul \
${strSub02}${strBrainMsk} \
${strSub03}${strT1w} &

wait

# Remove input files:
echo "------Removing input files"
rm ${strSub02}${strT1}.nii.gz
rm ${strSub02}${strInv2}.nii.gz
rm ${strSub02}${strPdw}.nii.gz
rm ${strSub02}${strT1w}.nii.gz
rm ${strSub02}${strBrainMsk}.nii.gz

echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Bias field removal on PDw image

echo "---Bias field removal on PDw image"

echo "------Estimate bias field in PDw image"

# Bias field estimation:
fast \
-n 1 \
-I 4 \
-l 20.0 \
-t 3 \
--nopve \
-b \
-B \
-o ${strSub04}${strPdw}_fast \
-H 0.1 \
${strSub03}${strPdw}

echo "------Remove bias field PDw image"

# Remove bias field and apply brain mask:
fslmaths ${strSub03}${strPdw} -div ${strSub04}${strPdw}_fast_bias ${strSub04}${strPdw}
wait

# Remove input files:
echo "------Removing input file"
rm ${strSub03}${strPdw}.nii.gz

echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Copy results into SPM directory for preregistration

echo "---Copy results into SPM directory for preregistration"

# Copy mp2rages:
fslchfiletype NIFTI ${strSub03}${strT1w} ${strSub05}${strSpmDirSrc}${strT1w} &
fslchfiletype NIFTI ${strSub03}${strT1} ${strSub05}${strSpmDirOtr}${strT1} &
fslchfiletype NIFTI ${strSub03}${strInv2} ${strSub05}${strSpmDirOtr}${strInv2} &
fslchfiletype NIFTI ${strSub04}${strPdw} ${strSub05}${strSpmDirOtr}${strPdw} &

# Copy combined mean:
fslchfiletype NIFTI ${strSub01}${strCombmean} ${strSub05}${strSpmDirRef}${strCombmean} &

wait

# Remove input files:
echo "------Removing input files"
rm ${strSub03}${strT1}.nii.gz
rm ${strSub03}${strInv2}.nii.gz
rm ${strSub03}${strT1w}.nii.gz
rm ${strSub04}${strPdw}.nii.gz

echo "---Done"
#-------------------------------------------------------------------------------

