#!/bin/sh


###############################################################################
# Copy JSON metadata into the BIDS directory.                                 #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Session ID:
strSess="20171023"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii"

# BIDS directory:
strBidsDir="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/BIDS/"

# BIDS subject ID:
strBidsSess="sub-01"

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
# *** Copy metadata for functional images

cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_010_c32.json ${strFunc}func_01.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run02_SERIES_012_c32.json ${strFunc}func_02.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run03_SERIES_014_c32.json ${strFunc}func_03.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run04_SERIES_022_c32.json ${strFunc}func_04.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run05_SERIES_024_c32.json ${strFunc}func_05.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run06_SERIES_026_c32.json ${strFunc}func_06.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_prf_run01_SERIES_028_c32.json ${strFunc}func_07.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run07_SERIES_030_c32.json ${strFunc}func_08.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_run08_SERIES_032_c32.json ${strFunc}func_09.json
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy metadata for opposite-phase-polarity SE images

# Note: The 'RL' image is copied as 'lr' on purpose (and vice versa), because
#       the original naming of files during the session was wrong.
cp ${strRaw}cmrrmbep2dseLR_SERIES_006_c32.json ${strSe}func_00.json
cp ${strRaw}cmrrmbep2dseRL_SERIES_005_c32.json ${strSeOp}func_00.json
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy metadata for mp2rage images

cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_015_c32.json ${strAnat}mp2rage_inv1.json
cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_016_c32.json ${strAnat}mp2rage_inv1_phase.json
cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_017_c32.json ${strAnat}mp2rage_pdw.json
cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_018_c32.json ${strAnat}mp2rage_pdw_phase.json
cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_019_c32.json ${strAnat}mp2rage_t1.json
cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_020_c32.json ${strAnat}mp2rage_uni.json
#------------------------------------------------------------------------------
