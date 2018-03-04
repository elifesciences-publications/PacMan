#!/bin/sh


###############################################################################
# Upload nii data to research data management server.                         #
#                                                                             #
# Note: You need to call this script with sudo priviliges in order to mount   #
#       the network folder.                                                   #
#                                                                             #
# This script is different for every subject because the initial file names   #
# after dicom to nii conversion differ between subjects (e.g.                 #
# BPep3dboldfunc01FOVRLs008a001). Nii files are uploaded (instead of dicom    #
# files) because data protection regulations require that images on which     #
# subjects could be identified relatively easily are stored separately in a   #
# private folder, and dicom files are impractical in this context. Whole      #
# brain mp2rage images (from which the face can be reconstructed) are stored  #
# separately in a private folder. Functional data (only containing a slab of  #
# occipital cortex) are stored in a non-private folder. Likewise, mp2rage     #
# images that have been registered to the functional data (i.e. small slab)   #
# and segmentations are uploaded to the non-private folder. Moreover, log     #
# files are uploaded.                                                         #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Session ID:
strSess="20180118"

# Path of network location (target directory):
strPthTrgt="//ca-um-nas201/fpn_rdm\$"

# Mount point (local directory where network drive will be mapped):
strPthMnt="/home/john/Documents/smb_research_data"

# Network directory for non-private data:
strDirPub="DM0412_IM_Pacman"

# Network directory for private data:
strDirPri="DM0412_IM_Pacman_P"

# Directory containing log files:
strPthLog="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/log"

# Parent source directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strPthMnt}/${strDirPub}/07\ -\ Raw data/${strSess}/func"

# Destination directory for same-phase-polarity SE images:
strSe=".../func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strPthPrnt}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strPthPrnt}/mp2rage/01_orig/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Preparations

# Mount the server:
sudo mount -t cifs ${strPthTrgt} ${strPthMnt} -o username=ingo.marquardt
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy log files

# Copy data to server using rsync:
rsync -a -v ${strPthLog} ${strPthMnt}/${strDirPub}
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

# Create directory for functional data (if it does not exist yet):
mkdir -p ${strFunc}


### TODO: rsync cannot be used to rename files during transfer


sudo rsync -a -v ${strRaw}BPep3dboldfunc01FOVRLs008a001.nii.gz ${strFunc}func_01.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc02FOVRLs010a001.nii.gz ${strFunc}func_02.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc03FOVRLs012a001.nii.gz ${strFunc}func_03.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc04FOVRLs014a001.nii.gz ${strFunc}func_04.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc05FOVRLs022a001.nii.gz ${strFunc}func_05.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc06FOVRLs024a001.nii.gz ${strFunc}func_06.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc07FOVRLpRFs026a001.nii.gz ${strFunc}func_07.nii.gz
sudo rsync -a -v ${strRaw}BPep3dboldfunc08FOVRLlongs028a001.nii.gz ${strFunc}func_08.nii.gz
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

sudo rsync -a -v ${strRaw}cmrrmbep2dseLRs005a001.nii.gz ${strSeOp}func_00.nii.gz
sudo rsync -a -v ${strRaw}cmrrmbep2dseRLs006a001.nii.gz ${strSe}func_00.nii.gz
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

# Note: Because the first MP2RAGEs was affected by a motion artefact, a second
# MP2RAGE was acquired for this subject at the end of the session.
sudo rsync -a -v ${strRaw}mp2rage07isop2s015a1001 ${strAnat}mp2rage_inv1
sudo rsync -a -v ${strRaw}mp2rage07isop2s016a1001 ${strAnat}mp2rage_inv1_phase
sudo rsync -a -v ${strRaw}mp2rage07isop2s017a1001 ${strAnat}mp2rage_pdw
sudo rsync -a -v ${strRaw}mp2rage07isop2s018a1001 ${strAnat}mp2rage_pdw_phase
sudo rsync -a -v ${strRaw}mp2rage07isop2s019a1001 ${strAnat}mp2rage_t1
sudo rsync -a -v ${strRaw}mp2rage07isop2s020a1001 ${strAnat}mp2rage_uni
#------------------------------------------------------------------------------
