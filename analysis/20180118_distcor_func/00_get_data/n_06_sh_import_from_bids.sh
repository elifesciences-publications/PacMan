#!/bin/sh


###############################################################################
# Import data from BIDS folder structure into PacMan analysis pipeline.       #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Session ID:
strSess="20180118"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# BIDS directory:
strBidsDir="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/BIDS/"

# BIDS subject ID:
strBidsSess="sub-09"

# BIDS directory containing functional data:
strBidsFunc="${strBidsDir}${strBidsSess}/func/"

# Destination directory for functional data:
strFunc="${strPthPrnt}/func/"

# BIDS directory containing same-phase-polarity SE images:
strBidsSe="${strBidsDir}${strBidsSess}/func_se/"

# Destination directory for same-phase-polarity SE images:
strSe="${strPthPrnt}/func_se/"

# BIDS directory containing opposite-phase-polarity SE images:
strBidsSeOp="${strBidsDir}${strBidsSess}/func_se_op/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strPthPrnt}/func_se_op/"

# BIDS directory containing mp2rage images:
strBidsAnat="${strBidsDir}${strBidsSess}/anat/"

# Destination directory for mp2rage images:
strAnat="${strPthPrnt}/mp2rage/01_orig/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

cp -r ${strBidsFunc} ${strFunc}
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

cp -r ${strBidsSe} ${strSe}
cp -r ${strBidsSeOp} ${strSeOp}
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

cp -r ${strBidsAnat} ${strAnat}
#------------------------------------------------------------------------------
