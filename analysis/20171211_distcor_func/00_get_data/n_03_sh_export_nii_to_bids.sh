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
strSess="20171211"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii"

# BIDS directory:
strBidsDir="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/BIDS/"

# BIDS subject ID:
strBidsSess="sub-06"

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

fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_008_c32 ${strFunc}func_01
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func02_FOV_RL_SERIES_010_c32 ${strFunc}func_02
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func03_FOV_RL_SERIES_012_c32 ${strFunc}func_03
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func04_FOV_RL_SERIES_014_c32 ${strFunc}func_04
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func05_FOV_RL_SERIES_022_c32 ${strFunc}func_05
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func06_FOV_RL_SERIES_024_c32 ${strFunc}func_06
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func07_FOV_RL_pRF_SERIES_026_c32 ${strFunc}func_07
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func08_FOV_RL_long_SERIES_028_c32 ${strFunc}func_08
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_LR_SERIES_005_c32 ${strSeOp}func_00
fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_006_c32 ${strSe}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

# Note: Because the first MP2RAGEs was affected by a motion artefact, a second
# MP2RAGE was acquired for this subject at the end of the session.
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_029_c32 ${strAnat}mp2rage_inv1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_030_c32 ${strAnat}mp2rage_inv1_phase
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_031_c32 ${strAnat}mp2rage_t1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_032_c32 ${strAnat}mp2rage_uni
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_033_c32 ${strAnat}mp2rage_pdw
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_034_c32 ${strAnat}mp2rage_pdw_phase
#------------------------------------------------------------------------------
