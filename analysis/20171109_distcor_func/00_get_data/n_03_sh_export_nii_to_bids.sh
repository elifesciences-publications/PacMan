#!/bin/sh


###############################################################################
# The purpose of this script is to copy the 'original' nii images, after      #
# DICOM to nii conversion, and reorient them to standard orientation. The     #
# contents of this script have to be adjusted individually for each session,  #
# as the original file names may differ from session to session.              #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Session ID:
strSess="20171109"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# BIDS directory:
strBidsDir="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/BIDS/"

# BIDS subject ID:
strBidsSess="sub-02"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strBidsDir}${strBidsSess}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strBidsDir}${strBidsSess}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strBidsDir}${strBidsSess}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strBidsDir}${strBidsSess}/anat/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Create BIDS directory tree

# Check whether the session directory already exists:
if [ ! -d "${strBidsDir}${strBidsSess}" ];
then
	echo "Create BIDS directory for ${strBidsDir}${strBidsSess}"

	# Create BIDS subject parent directory:
	mkdir "${strBidsDir}${strBidsSess}"

	# Create BIDS directory tree:
	mkdir "${strAnat}"
	mkdir "${strFunc}"
	mkdir "${strSe}"
	mkdir "${strSeOp}"
else
	echo "Directory for ${strBidsDir}${strBidsSess} does already exist."
fi
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_009_c32 ${strFunc}func_01
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func02_FOV_RL_SERIES_011_c32 ${strFunc}func_02
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func03_FOV_RL_SERIES_013_c32 ${strFunc}func_03
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func04_FOV_RL_SERIES_021_c32 ${strFunc}func_04
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func05_FOV_RL_SERIES_023_c32 ${strFunc}func_05
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func06_FOV_RL_SERIES_025_c32 ${strFunc}func_06
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func07pRF_FOV_RL_SERIES_027_c32 ${strFunc}func_07
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func08long_FOV_RL_SERIES_029_c32 ${strFunc}func_08
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

# Note: The original file name ('RL') was wrong.
fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_006_c32 ${strSeOp}func_00
fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_007_c32 ${strSe}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_014_c32 ${strAnat}mp2rage_inv1
# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_015_c32 ${strAnat}mp2rage_inv1_phase
# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_016_c32 ${strAnat}mp2rage_pdw
# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_017_c32 ${strAnat}mp2rage_pdw_phase
# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_018_c32 ${strAnat}mp2rage_t1
# fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_019_c32 ${strAnat}mp2rage_uni

# The mp2rage images obtained during session 20171109 were of inferior quality.
# Extrassession mp2rage images are used for segmentaion instead.
fslreorient2std /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/raw_data_extrasession/mp2rage_inv1.nii.gz ${strAnat}mp2rage_inv1
fslreorient2std /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/raw_data_extrasession/mp2rage_pdw.nii.gz ${strAnat}mp2rage_pdw
fslreorient2std /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/raw_data_extrasession/mp2rage_t1.nii.gz ${strAnat}mp2rage_t1
fslreorient2std /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171109/nii_distcor/raw_data_extrasession/mp2rage_uni.nii.gz ${strAnat}mp2rage_uni
#------------------------------------------------------------------------------
