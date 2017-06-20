#!/bin/sh


################################################################################
# The purpose of this script is to crop and upsample images as part of the     #
# mp2rage to combined mean registration pipeline.                              #
################################################################################


#-------------------------------------------------------------------------------
### Define session IDs & paths

# Parent directory:
strParent="/home/john/Desktop/20151130_02_distcor_02092016/"

# Subdirectories:
#strSub01="${strParent}mp2rage/03_reg/01_in/"
strSub02="${strParent}mp2rage/03_reg/05_prereg/"
strSub03="${strParent}mp2rage/03_reg/06_crop/"
strSub04="${strParent}mp2rage/03_reg/07_up/"
#strSub05="${strParent}mp2rage/03_reg/08_wm_seg/"

# Input files:

# Combined mean image:
strCombmean="combined_mean"

# Names of mp2rage image components (without file suffix):
strT1="mp2rage_t1"
strInv2="mp2rage_inv2"
strPdw="mp2rage_pdw"
strT1w="mp2rage_t1w"

# SPM prefix:
strSpm="r"

# SPM directory names:
strSpmDirRef="combined_mean/"
strSpmDirSrc="mp2rage_t1w/"
strSpmDirOtr="mp2rage_other/"

# Image with coordinates for cropping:
strCrop="${strParent}evc_cubes/for_feat/func_mean_points4crop"
#-------------------------------------------------------------------------------


echo "-Crop & upsample mp2rage for registration"


#-------------------------------------------------------------------------------
### Crop images

echo "--Crop images"
date

# Get coordinates [x y z t] of non-zero voxels in mask:
strTmp01=`fslstats ${strCrop} -w`

# Remove last characters (representing the time dimension):
strTmp01=${strTmp01::-4}

# Add new time dimension (first to last volume):
strTmp01="${strTmp01}0 -1"

# Crop images:
fslroi ${strSub02}${strSpmDirRef}${strCombmean} ${strSub03}${strCombmean} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strT1} ${strSub03}${strT1} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strInv2} ${strSub03}${strInv2} ${strTmp01} &
fslroi ${strSub02}${strSpmDirOtr}${strSpm}${strPdw} ${strSub03}${strPdw} ${strTmp01} &
fslroi ${strSub02}${strSpmDirSrc}${strSpm}${strT1w} ${strSub03}${strT1w} ${strTmp01} &

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Upsample

echo "--Upsample"

# Get dimensions of cropped image:

strDim01=`fslinfo ${strSub03}${strCombmean} | grep -w dim1 | sed -e 's/dim1//'`
strDim02=`fslinfo ${strSub03}${strCombmean} | grep -w dim2 | sed -e 's/dim2//'`
strDim03=`fslinfo ${strSub03}${strCombmean} | grep -w dim3 | sed -e 's/dim3//'`

# Get voxel size of cropped image:

strPixdim01=`fslinfo ${strSub03}${strCombmean} | grep -w pixdim1 | sed -e 's/pixdim1//'`
strPixdim02=`fslinfo ${strSub03}${strCombmean} | grep -w pixdim2 | sed -e 's/pixdim2//'`
strPixdim03=`fslinfo ${strSub03}${strCombmean} | grep -w pixdim3 | sed -e 's/pixdim3//'`

# Create variables for new dimensions:

varDim01=`bc <<< ${strDim01}*2`
varDim02=`bc <<< ${strDim02}*2`
varDim03=`bc <<< ${strDim03}*2`

# Create variables for new voxel sizes:

varPixdim01=`bc <<< ${strPixdim01}*0.5`
varPixdim02=`bc <<< ${strPixdim02}*0.5`
varPixdim03=`bc <<< ${strPixdim03}*0.5`

# Add zero before the decimal point (only necessary when resolution is
# sub-millimeter):

varPixdim01="0${varPixdim01}"
varPixdim02="0${varPixdim02}"
varPixdim03="0${varPixdim03}"

echo "---Upsampling images"
echo "------Image dimensions before upsampling:"
echo "---------x: ${strDim01}"
echo "---------y: ${strDim02}"
echo "---------z: ${strDim03}"
echo "---------voxel dimension 1: ${strPixdim01}"
echo "---------voxel dimension 2: ${strPixdim02}"
echo "---------voxel dimension 3: ${strPixdim03}"
echo "------Image dimensions after upsampling:"
echo "---------x: ${varDim01}"
echo "---------y: ${varDim02}"
echo "---------z: ${varDim03}"
echo "---------voxel dimension 1: ${varPixdim01}"
echo "---------voxel dimension 2: ${varPixdim02}"
echo "---------voxel dimension 3: ${varPixdim03}"

echo "---Creating header"
date

# Create header:
fslcreatehd \
${varDim01} \
${varDim02} \
${varDim03} \
1 \
${varPixdim01} \
${varPixdim02} \
${varPixdim03} \
1 0 0 0 16 \
${strSub04}${strCombmean}_tmp_hdr

echo "---Upsampling images"
date

#echo "---Upsampling combined mean"
#date
# Upsample combined mean:
flirt \
-in ${strSub03}${strCombmean} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub04}${strCombmean} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub04}${strCombmean}_tmp_hdr &

#echo "---Upsampling T1"
#date
# Upsample T1:
flirt \
-in ${strSub03}${strT1} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub04}${strT1} \
-paddingsize 0.0 \
-interp sinc \
-ref ${strSub04}${strCombmean}_tmp_hdr &

#echo "---Upsampling INV2"
#date
# Upsample INV2:
flirt \
-in ${strSub03}${strInv2} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub04}${strInv2} \
-paddingsize 0.0 \
-interp sinc \
-ref ${strSub04}${strCombmean}_tmp_hdr &

#echo "---Upsampling PDw"
#date
# Upsample PDw:
flirt \
-in ${strSub03}${strPdw} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub04}${strPdw} \
-paddingsize 0.0 \
-interp sinc \
-ref ${strSub04}${strCombmean}_tmp_hdr &

#echo "---Upsampling T1w"
#date
# Upsample T1w:
flirt \
-in ${strSub03}${strT1w} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub04}${strT1w} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub04}${strCombmean}_tmp_hdr &

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Preparations for SPM

# Create SPM-style 'mansion' directory tree:
#mkdir ${strSub05}${strSpmDirRef}
#mkdir ${strSub05}${strSpmDirSrc}
#mkdir ${strSub05}${strSpmDirOtr}

# Move files:
#cp ${strSub04}${strCombmean}.nii.gz \
#${strSub05}${strSpmDirRef}${strCombmean}.nii.gz
#cp ${strSub04}${strT1}.nii.gz \
#${strSub05}${strSpmDirOtr}${strT1}.nii.gz
#cp ${strSub04}${strInv2}.nii.gz \
#${strSub05}${strSpmDirOtr}${strInv2}.nii.gz
#cp ${strSub04}${strPdw}.nii.gz \
#${strSub05}${strSpmDirOtr}${strPdw}.nii.gz
#cp ${strSub04}${strT1w}.nii.gz \
#${strSub05}${strSpmDirSrc}${strT1w}.nii.gz

# Un-compress files:
#gunzip ${strSub05}${strSpmDirRef}${strCombmean}.nii.gz
#gunzip ${strSub05}${strSpmDirOtr}${strT1}.nii.gz
#gunzip ${strSub05}${strSpmDirOtr}${strInv2}.nii.gz
#gunzip ${strSub05}${strSpmDirOtr}${strPdw}.nii.gz
#gunzip ${strSub05}${strSpmDirSrc}${strT1w}.nii.gz
#-------------------------------------------------------------------------------

