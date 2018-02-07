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
strSess="20180111"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strPthPrnt}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strPthPrnt}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
sreSeOp="${strPthPrnt}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strPthPrnt}/mp2rage/01_orig/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

fslreorient2std ${strRaw}BPep3dboldfunc01FOVRLs011a001 ${strFunc}func_01
fslreorient2std ${strRaw}BPep3dboldfunc02FOVRLs013a001 ${strFunc}func_02
fslreorient2std ${strRaw}BPep3dboldfunc03FOVRLs015a001 ${strFunc}func_03
fslreorient2std ${strRaw}BPep3dboldfunc04FOVRLs017a001 ${strFunc}func_04
fslreorient2std ${strRaw}BPep3dboldfunc05FOVRLs025a001 ${strFunc}func_05
fslreorient2std ${strRaw}BPep3dboldfunc06FOVRLs027a001 ${strFunc}func_06
fslreorient2std ${strRaw}BPep3dboldfunc07FOVRLpRFs029a001 ${strFunc}func_07
fslreorient2std ${strRaw}BPep3dboldfunc08FOVRLlongs031a001 ${strFunc}func_08
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

fslreorient2std ${strRaw}cmrrmbep2dseLRs007a001 ${strSe}func_00
fslreorient2std ${strRaw}cmrrmbep2dseRLs008a001 ${sreSeOp}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

# Note: Because the first MP2RAGEs was affected by a motion artefact, a second
# MP2RAGE was acquired for this subject at the end of the session.
fslreorient2std ${strRaw}mp2rage07isop2s018a1001 ${strAnat}mp2rage_inv1
fslreorient2std ${strRaw}mp2rage07isop2s019a1001 ${strAnat}mp2rage_inv1_phase
fslreorient2std ${strRaw}mp2rage07isop2s020a1001 ${strAnat}mp2rage_t1
fslreorient2std ${strRaw}mp2rage07isop2s021a1001 ${strAnat}mp2rage_uni
fslreorient2std ${strRaw}mp2rage07isop2s022a1001 ${strAnat}mp2rage_pdw
fslreorient2std ${strRaw}mp2rage07isop2s023a1001 ${strAnat}mp2rage_pdw_phase
#------------------------------------------------------------------------------
