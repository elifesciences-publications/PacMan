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
strSess="20171023"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strPthPrnt}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strPthPrnt}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strPthPrnt}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strPthPrnt}/mp2rage/01_orig/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLs010a001 ${strFunc}func_01
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun02s012a001 ${strFunc}func_02
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun03s014a001 ${strFunc}func_03
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun04s022a001 ${strFunc}func_04
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun05s024a001 ${strFunc}func_05
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun06s026a001 ${strFunc}func_06
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLprfrun01s028a001 ${strFunc}func_07
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun07s030a001 ${strFunc}func_08
fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLrun08s032a001 ${strFunc}func_09
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

# Note: The 'RL' image is copied as 'lr' on purpose (and vice versa), because
#       the original naming of files during the session was wrong.
fslreorient2std ${strRaw}cmrrmbep2dseLRs006a001 ${strSeOp}func_00
fslreorient2std ${strRaw}cmrrmbep2dseRLs005a001 ${strSe}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

fslreorient2std ${strRaw}mp2rage07isop2s015a1001 ${strAnat}mp2rage_inv1
fslreorient2std ${strRaw}mp2rage07isop2s016a1001 ${strAnat}mp2rage_inv1_phase
fslreorient2std ${strRaw}mp2rage07isop2s017a1001 ${strAnat}mp2rage_pdw
fslreorient2std ${strRaw}mp2rage07isop2s018a1001 ${strAnat}mp2rage_pdw_phase
fslreorient2std ${strRaw}mp2rage07isop2s019a1001 ${strAnat}mp2rage_t1
fslreorient2std ${strRaw}mp2rage07isop2s020a1001 ${strAnat}mp2rage_uni
#------------------------------------------------------------------------------
