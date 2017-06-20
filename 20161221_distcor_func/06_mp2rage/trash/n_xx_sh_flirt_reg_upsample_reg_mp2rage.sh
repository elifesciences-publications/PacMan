#!/bin/sh


################################################################################
# The purpose of this script is to register images from the mp2rage sequence   #
# to the combined mean functional image of the same session.                   #
################################################################################
# IMPORTANT: Input images need to be reoriented to standard.                   #
################################################################################


echo "-------------------------------------------------------------------------"
echo "-Registration of mp2rage images to combined mean"
date
echo "-------------------------------------------------------------------------"


#-------------------------------------------------------------------------------
### Define session IDs & paths

# Parent directory:
strParent="/home/john/Desktop/20151130_02_distcor_02092016/"

# Subdirectories:
strSub_01="${strParent}mp2rage/04_reg/01_in/"
strSub_02="${strParent}mp2rage/04_reg/02_prereg/"
strSub_03="${strParent}mp2rage/04_reg/03_crop/"
strSub_04="${strParent}mp2rage/04_reg/04_up/"
strSub_05="${strParent}mp2rage/04_reg/05_reg/"

# Input files:

# Reference weight:
strRefweight="20151130_02_distcor_spm_moco_refweight"

# Combined mean image:
strCombmean="combined_mean"

# Names of mp2rage image components:
strT1="mp2rage_t1"
strInv2="mp2rage_inv2"
strPdw="mp2rage_pdw.nii.gz"
strT1w="mp2rage_t1w.nii.gz"

# Image with coordinates for cropping:
strCrop="${strParent}evc_cubes/for_feat/func_mean_points4crop"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Pre-registration to combined mean

echo "--Pre-registration to combined mean"

# Calculate transformation from mp2rage to combined_mean:
echo "---Calculate transformation from mp2rage to combined_mean"
date
flirt \
-cost normmi \
-searchcost normmi \
-interp trilinear \
-bins 256 \
-dof 6 \
-minsampling 0.7 \
-in ${strSub_01}${strPdw} \
-ref ${strSub_01}${strCombmean} \
-refweight ${strSub_01}${strRefweight} \
-omat ${strSub_02}mat_mp2rage_to_combinedmean
date
echo "---Done"

echo "---Apply transformation to mp2rage images"

# Apply transformation to T1 image:
# echo "---Apply transformation matrix to T1w image"
# date
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_01}${strT1} \
-ref ${strSub_01}${strCombmean} \
-applyxfm -init ${strSub_02}mat_mp2rage_to_combinedmean \
-out ${strSub_02}${strT1} &
# date
# echo "---Done"

# Apply transformation to INV2 image:
# echo "---Apply transformation matrix to T1w image"
# date
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_01}${strInv2} \
-ref ${strSub_01}${strCombmean} \
-applyxfm -init ${strSub_02}mat_mp2rage_to_combinedmean \
-out ${strSub_02}${strInv2} &
# date
# echo "---Done"

# Apply transformation to PDw image:
# echo "---Apply transformation matrix to T1w image"
# date
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_01}${strPdw} \
-ref ${strSub_01}${strCombmean} \
-applyxfm -init ${strSub_02}mat_mp2rage_to_combinedmean \
-out ${strSub_02}${strPdw} &
# date
# echo "---Done"

# Apply transformation to T1w image:
# echo "---Apply transformation matrix to T1w image"
# date
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_01}${strT1w} \
-ref ${strSub_01}${strCombmean} \
-applyxfm -init ${strSub_02}mat_mp2rage_to_combinedmean \
-out ${strSub_02}${strT1w} &
# date
# echo "---Done"

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Crop images

echo "--Crop images"
date

# Get coordinates [x y z t] of non-zero voxels in mask:
strTmp_01=`fslstats ${strCrop} -w`

# Remove last characters (representing the time dimension):
strTmp_01=${strTmp_01::-4}

# Add new time dimension (first to last volume):
strTmp_01="${strTmp_01}0 -1"

# Crop images:

#echo "---fslroi ${strSub_01}${strCombmean} ${strSub_03}${strCombmean}" \
#	"${strTmp_01}"
fslroi ${strSub_01}${strCombmean} ${strSub_03}${strCombmean} ${strTmp_01} &
#date

#echo "---fslroi ${strSub_02}${strM0fit} ${strSub_03}${strM0fit} ${strTmp_01}"
fslroi ${strSub_02}${strT1} ${strSub_03}${strT1} ${strTmp_01} &
#date

#echo "---fslroi ${strSub_02}${strM0fit} ${strSub_03}${strM0fit} ${strTmp_01}"
fslroi ${strSub_02}${strInv2} ${strSub_03}${strInv2} ${strTmp_01} &
#date

#echo "---fslroi ${strSub_02}${strM0fit} ${strSub_03}${strM0fit} ${strTmp_01}"
fslroi ${strSub_02}${strPdw} ${strSub_03}${strPdw} ${strTmp_01} &
#date

#echo "---fslroi ${strSub_02}${strM0fit} ${strSub_03}${strM0fit} ${strTmp_01}"
fslroi ${strSub_02}${strT1w} ${strSub_03}${strT1w} ${strTmp_01} &
#date

#echo "---fslroi ${strSub_02}${strRefweight} ${strSub_03}${strRefweight}" \
#	"${strTmp_01}"
fslroi ${strSub_01}${strRefweight} ${strSub_03}${strRefweight} ${strTmp_01} &
#date

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Upsample

echo "--Upsample"

# Get dimensions of cropped image:

str_dim_01=`fslinfo ${strSub_03}${strCombmean} | grep -w dim1 | sed -e 's/dim1//'`
str_dim_02=`fslinfo ${strSub_03}${strCombmean} | grep -w dim2 | sed -e 's/dim2//'`
str_dim_03=`fslinfo ${strSub_03}${strCombmean} | grep -w dim3 | sed -e 's/dim3//'`

# Get voxel size of cropped image:

str_pixdim_01=`fslinfo ${strSub_03}${strCombmean} | grep -w pixdim1 | sed -e 's/pixdim1//'`
str_pixdim_02=`fslinfo ${strSub_03}${strCombmean} | grep -w pixdim2 | sed -e 's/pixdim2//'`
str_pixdim_03=`fslinfo ${strSub_03}${strCombmean} | grep -w pixdim3 | sed -e 's/pixdim3//'`

# Create variables for new dimensions:

var_dim_01=`bc <<< ${str_dim_01}*2`
var_dim_02=`bc <<< ${str_dim_02}*2`
var_dim_03=`bc <<< ${str_dim_03}*2`

# Create variables for new voxel sizes:

var_pixdim_01=`bc <<< ${str_pixdim_01}*0.5`
var_pixdim_02=`bc <<< ${str_pixdim_02}*0.5`
var_pixdim_03=`bc <<< ${str_pixdim_03}*0.5`

# Add zero before the decimal point (only necessary when resolution is
# sub-millimeter):

var_pixdim_01="0${var_pixdim_01}"
var_pixdim_02="0${var_pixdim_02}"
var_pixdim_03="0${var_pixdim_03}"

echo "---Upsampling images"
echo "------Image dimensions before upsampling:"
echo "---------x: ${str_dim_01}"
echo "---------y: ${str_dim_02}"
echo "---------z: ${str_dim_03}"
echo "---------voxel dimension 1: ${str_pixdim_01}"
echo "---------voxel dimension 2: ${str_pixdim_02}"
echo "---------voxel dimension 3: ${str_pixdim_03}"
echo "------Image dimensions after upsampling:"
echo "---------x: ${var_dim_01}"
echo "---------y: ${var_dim_02}"
echo "---------z: ${var_dim_03}"
echo "---------voxel dimension 1: ${var_pixdim_01}"
echo "---------voxel dimension 2: ${var_pixdim_02}"
echo "---------voxel dimension 3: ${var_pixdim_03}"

echo "---Creating header"
date

# Create header:
fslcreatehd \
${var_dim_01} \
${var_dim_02} \
${var_dim_03} \
1 \
${var_pixdim_01} \
${var_pixdim_02} \
${var_pixdim_03} \
1 0 0 0 16 \
${strSub_04}${strCombmean}_tmp_hdr

echo "---Upsampling images"
date

#echo "---Upsampling combined mean"
#date
# Upsample combined mean:
flirt \
-in ${strSub_03}${strCombmean} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strCombmean} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

#echo "---Upsampling T1"
#date
# Upsample T1:
flirt \
-in ${strSub_03}${strT1} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strT1} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

#echo "---Upsampling INV2"
#date
# Upsample INV2:
flirt \
-in ${strSub_03}${strInv2} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strInv2} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

#echo "---Upsampling PDw"
#date
# Upsample PDw:
flirt \
-in ${strSub_03}${strPdw} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strPdw} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

#echo "---Upsampling T11"
#date
# Upsample T11:
flirt \
-in ${strSub_03}${strT1w} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strT1w} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

#echo "---Upsampling refweight"
#date
# Upsample refweight:
flirt \
-in ${strSub_03}${strRefweight} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strSub_04}${strRefweight} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strSub_04}${strCombmean}_tmp_hdr &

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Registration of upsampled images to combined mean

echo "--Registration of upsampled images to combined mean"

# Calculate transformation from mp2ragew to combined_mean:
echo "---Calculating transformation from mp2rage to combined mean"
date
flirt \
-cost normmi \
-searchcost normmi \
-interp trilinear \
-bins 512 \
-dof 6 \
-minsampling ${var_pixdim_01} \
-refweight ${strSub_04}${strRefweight} \
-in ${strSub_04}${strT1w} \
-ref ${strSub_04}${strCombmean} \
-omat ${strSub_05}mat_mp2rage_to_combinedmean

echo "---Applying transformation to mp2rage images"
date

# Apply transformation to fitted T1 image:
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_04}${strT1} \
-ref ${strSub_04}${strCombmean} \
-applyxfm -init ${strSub_05}mat_mp2rage_to_combinedmean \
-out ${strSub_05}${strT1} &

# Apply transformation to fitted INV2 image:
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_04}${strInv2} \
-ref ${strSub_04}${strCombmean} \
-applyxfm -init ${strSub_05}mat_mp2rage_to_combinedmean \
-out ${strSub_05}${strInv2} &

# Apply transformation to fitted PDw image:
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_04}${strPdw} \
-ref ${strSub_04}${strCombmean} \
-applyxfm -init ${strSub_05}mat_mp2rage_to_combinedmean \
-out ${strSub_05}${strPdw} &

# Apply transformation to fitted T1w image:
flirt \
-interp trilinear \
-dof 6 \
-in ${strSub_04}${strT1w} \
-ref ${strSub_04}${strCombmean} \
-applyxfm -init ${strSub_05}mat_mp2rage_to_combinedmean \
-out ${strSub_05}${strT1w} &

wait
date
echo "---Done"
#-------------------------------------------------------------------------------


# To be followed up by segmentation.


