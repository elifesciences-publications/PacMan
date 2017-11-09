#!/bin/sh


###############################################################################
# The purpose of this script is to upsample an nii timeseries.                #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters:

# Input file - without file extension:
strPthIn="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/feat_level_1/func_07.feat/filtered_func_data"

# Output file:
strPthOut="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/retinotopy/func_prepro/filtered_func_up"

# Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# quater of the previous voxel size):
varUpFac=0.5
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Upsample images:

# Calculate inverse of upsampling factor (for caculation of new matrix size):
varUpInv=`bc <<< 1/${varUpFac}`

# Get dimensions of current input image:
strDim01=`fslinfo ${strPthIn} | grep -w dim1 | sed -e 's/dim1//'`
strDim02=`fslinfo ${strPthIn} | grep -w dim2 | sed -e 's/dim2//'`
strDim03=`fslinfo ${strPthIn} | grep -w dim3 | sed -e 's/dim3//'`
strDim04=`fslinfo ${strPthIn} | grep -w dim4 | sed -e 's/dim4//'`

# Get voxel size of current input image:
strPixdim01=`fslinfo ${strPthIn} | grep -w pixdim1 | sed -e 's/pixdim1//'`
strPixdim02=`fslinfo ${strPthIn} | grep -w pixdim2 | sed -e 's/pixdim2//'`
strPixdim03=`fslinfo ${strPthIn} | grep -w pixdim3 | sed -e 's/pixdim3//'`
strPixdim04=`fslinfo ${strPthIn} | grep -w pixdim4 | sed -e 's/pixdim4//'`

# Create variables for new dimensions (matrix size):
varDim01=`bc <<< ${strDim01}*${varUpInv}`
varDim02=`bc <<< ${strDim02}*${varUpInv}`
varDim03=`bc <<< ${strDim03}*${varUpInv}`

# Create variables for new voxel sizes:
varPixdim01=`bc <<< ${strPixdim01}*${varUpFac}`
varPixdim02=`bc <<< ${strPixdim02}*${varUpFac}`
varPixdim03=`bc <<< ${strPixdim03}*${varUpFac}`

# Add zero before the decimal point (only necessary when resolution is
# sub-millimeter):
varPixdim01="0${varPixdim01}"
varPixdim02="0${varPixdim02}"
varPixdim03="0${varPixdim03}"

echo "---------Image dimensions before upsampling:"
echo "------------x: ${strDim01}"
echo "------------y: ${strDim02}"
echo "------------z: ${strDim03}"
echo "------------voxel dimension 1: ${strPixdim01}"
echo "------------voxel dimension 2: ${strPixdim02}"
echo "------------voxel dimension 3: ${strPixdim03}"
echo "---------Image dimensions after upsampling:"
echo "------------x: ${varDim01}"
echo "------------y: ${varDim02}"
echo "------------z: ${varDim03}"
echo "------------voxel dimension 1: ${varPixdim01}"
echo "------------voxel dimension 2: ${varPixdim02}"
echo "------------voxel dimension 3: ${varPixdim03}"

echo "------Creating header"

# Create header:
fslcreatehd \
${varDim01} ${varDim02} ${varDim03} ${strDim04} \
${varPixdim01} ${varPixdim02} ${varPixdim03} ${strPixdim04} 0 0 0 16 \
${strPthIn}_tmp_hdr

echo "------Upsampling"

# Upsample current image:
flirt \
-in ${strPthIn} \
-applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat \
-out ${strPthOut} \
-paddingsize 0.0 \
-interp trilinear \
-ref ${strPthIn}_tmp_hdr

# Remove temporary header image:
rm ${strPthIn}_tmp_hdr.nii.gz
# -----------------------------------------------------------------------------
