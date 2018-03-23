#!/bin/bash


###############################################################################
# Copy JSON metadata into the BIDS directory.                                 #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Parent directory:
strPthPrnt="${pacman_data_path}${pacman_sub_id}/nii"

# BIDS directory:
strBidsDir="${pacman_data_path}BIDS/"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strBidsDir}${pacman_sub_id_bids}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strBidsDir}${pacman_sub_id_bids}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strBidsDir}${pacman_sub_id_bids}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strBidsDir}${pacman_sub_id_bids}/anat/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy metadata for functional images

cp ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_009_c32.json ${strFunc}func_01.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func02_FOV_RL_SERIES_011_c32.json ${strFunc}func_02.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func03_FOV_RL_SERIES_013_c32.json ${strFunc}func_03.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func04_FOV_RL_SERIES_021_c32.json ${strFunc}func_04.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func05_FOV_RL_SERIES_023_c32.json ${strFunc}func_05.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func06_FOV_RL_SERIES_025_c32.json ${strFunc}func_06.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func07pRF_FOV_RL_SERIES_027_c32.json ${strFunc}func_07.json
cp ${strRaw}PROTOCOL_BP_ep3d_bold_func08long_FOV_RL_SERIES_029_c32.json ${strFunc}func_08.json
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy metadata for opposite-phase-polarity SE images

# Note: The original file name ('RL') was wrong.
cp ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_006_c32.json ${strSeOp}func_00.json
cp ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_007_c32.json ${strSe}func_00.json
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy metadata for mp2rage images

# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_014_c32.json ${strAnat}mp2rage_inv1.json
# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_015_c32.json ${strAnat}mp2rage_inv1_phase.json
# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_016_c32.json ${strAnat}mp2rage_pdw.json
# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_017_c32.json ${strAnat}mp2rage_pdw_phase.json
# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_018_c32.json ${strAnat}mp2rage_t1.json
# cp ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_019_c32.json ${strAnat}mp2rage_uni.json

# The mp2rage images obtained during session 20171109 were of inferior quality.
# Extrassession mp2rage images are used for segmentaion instead.
# cp ${pacman_data_path}20171109/raw_data_extrasession/mp2rage_inv1.nii.gz ${strAnat}mp2rage_inv1.json
# cp ${pacman_data_path}20171109/raw_data_extrasession/mp2rage_pdw.nii.gz ${strAnat}mp2rage_pdw.json
# cp ${pacman_data_path}20171109/raw_data_extrasession/mp2rage_t1.nii.gz ${strAnat}mp2rage_t1.json
# cp ${pacman_data_path}20171109/raw_data_extrasession/mp2rage_uni.nii.gz ${strAnat}mp2rage_uni.json

echo "The mp2rage images obtained during this session were of inferior quality. \
      This folder contains mp2rage images from a separate session which were used \
      for segmentation." > ${strAnat}info.txt
#------------------------------------------------------------------------------
