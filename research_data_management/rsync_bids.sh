#!/bin/sh


###############################################################################
# Upload nii data to research data management server.                         #
#                                                                             #
# Note: You need to call this script with sudo priviliges in order to mount   #
#       the network folder.                                                   #
#                                                                             #
# Nii files are uploaded (instead of dicom files) because data protection     #
# regulations require that images are de-faced. Because the coverage of the   #
# functional time series is restricted to occipital cortex, the anterior part #
# of mp2rage images are simply set to zero.                                   #
###############################################################################


#------------------------------------------------------------------------------
# *** Define parameters


# Path of network location (target directory):
strTrgt="//ca-um-nas201/fpn_rdm\$"

# Mount point (local directory where network drive will be mapped):
strMnt="/home/john/Documents/smb_research_data"

# Network directory for non-private data:
strPub="DM0412_IM_Pacman"

# Network directory for private data:
strPri="DM0412_IM_Pacman_P"

# Source directory BIDS data structure:
strBidsSrc="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/BIDS/"

# Target directory BIDS data structure:
strBidsTrg="${strMnt}/${strPub}/07_Raw_data/"

# Source directory containing log files:
# strSrcLog="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/log"

# Target directory for log files:
# strTrgLog="${strMnt}/${strPub}/07\ -\ Raw data/${strSess}/log"

# Source directory retinotopy data:
# strSrcPrf="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor/retinotopy/pRF_results_up/"

# Destination directory for retinotopy data:
# strTrgPrf="/home/john/Documents/smb_research_data/DM0412_IM_Pacman/09\ -\ Data\ after\ cleaning/${strSess}/pRF_results_up"

# Source directory statistical maps:
# strSrcStat="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor/stat_maps_up/"

# Destination directory for statistical maps:
# strTrgStat="/home/john/Documents/smb_research_data/DM0412_IM_Pacman/09\ -\ Data\ after\ cleaning/${strSess}/stat_maps_up"

# Source directory spatial correlation plots:
# strSrcMocoPlt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor/spm_reg_moco_params/"

# Target directory spatial correlation plots:
# strTrgMocoPlt="/home/john/Documents/smb_research_data/DM0412_IM_Pacman/09\ -\ Data\ after\ cleaning/${strSess}/spm_reg_moco_params"

# Source directory registered mp2rage:
# strSrcRegAnat="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor/mp2rage/04_seg/"

# Target directory regitered mp2rage"
# strTrgRegAnat="/home/john/Documents/smb_research_data/DM0412_IM_Pacman/09\ -\ Data\ after\ cleaning/${strSess}/mp2rage/04_seg"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Preparations

# Mount the server:
sudo mount -t cifs ${strTrgt} ${strMnt} -o username=ingo.marquardt,vers=2.0

# Change owner & group (probably because the server is using a windows file
# system this does not work):
# sudo chown -R john ./smb_research_data/
# sudo chgrp -R john ./smb_research_data/
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy log files

# Create target directory (if it does not exist yet):
# sudo mkdir -p ${strTrgLog}

# Copy data to server using rsync:
# sudo rsync -a -v -c "${strSrcLog} ${strTrgLog}"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy BIDS data structure

# Create directory (if it does not exist yet):
# sudo mkdir -p ${strTrgAnat}

echo "Copy BIDS data structure"
# echo "sudo rsync -a -v -c ${strBidsSrc} ${strBidsTrg}"
sudo rsync -a -v -c ${strBidsSrc} ${strBidsTrg}
#------------------------------------------------------------------------------


##------------------------------------------------------------------------------
## *** Copy retinotopic maps (intermediate result)
#
## List of files to copy:
#aryNii=(pRF_results_eccentricity.nii.gz \
#        pRF_results_ovrlp_ctnr_left.nii.gz \
#        pRF_results_ovrlp_ctnr_right.nii.gz \
#        pRF_results_ovrlp_ratio_left.nii.gz \
#        pRF_results_ovrlp_ratio_right.nii.gz \
#        pRF_results_polar_angle.nii.gz \
#        pRF_results_R2.nii.gz \
#        pRF_results_SD.nii.gz \
#        pRF_results_x_pos.nii.gz \
#        pRF_results_y_pos.nii.gz)
#
## Create directory (if it does not exist yet):
## sudo mkdir -p ${strTrgPrf}
#
#for idxFile in ${aryNii[@]}
#do
#  echo "sudo rsync -a -v -c ${strSrcPrf}${idxFile} ${strTrgPrf}/"
#  # sudo rsync -a -v -c "${strSrcPrf}${idxFile} ${strTrgPrf}/"
#done
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------
## *** Copy statistical maps (intermediate result)
#
## Create target directory (if it does not exist yet):
## sudo mkdir -p ${strTrgStat}
#
## Copy data to server using rsync:
#echo "sudo rsync -a -v -c ${strSrcStat} ${strTrgStat}/"
## sudo rsync -a -v -c "${strSrcStat} ${strTrgStat}/"
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------
## *** Copy spatial correlation plot (intermediate result)
#
## Create target directory (if it does not exist yet):
## sudo mkdir -p ${strTrgMocoPlt}
#
## Copy data to server using rsync:
#echo "sudo rsync -a -v -c ${strSrcMocoPlt} ${strTrgMocoPlt}/"
## sudo rsync -a -v -c "${strSrcMocoPlt} ${strTrgMocoPlt}/"
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------
## *** Copy registered mp2rage (intermediate result)
#
## List of files to copy:
#aryNii=(combined_mean.nii.gz \
#        combined_mean_tSNR.nii.gz \
#        mp2rage_inv1.nii.gz \
#        mp2rage_pdw.nii.gz \
#        mp2rage_t1.nii.gz \
#        mp2rage_uni.nii.gz)
#
## Create directory (if it does not exist yet):
## sudo mkdir -p ${strTrgRegAnat}
#
#for idxFile in ${aryNii[@]}
#do
#  echo "sudo rsync -a -v -c ${strSrcRegAnat}${idxFile} ${strTrgRegAnat}/"
#  # sudo rsync -a -v -c "${strSrcRegAnat}${idxFile} ${strTrgRegAnat}/"
#done
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------
## *** Copy segmentation (intermediate result)
#
## Source directory registered mp2rage:
#strSrcRegAnat="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor/mp2rage/04_seg/"
#
## Target directory regitered mp2rage"
#strTrgRegAnat="/home/john/Documents/smb_research_data/DM0412_IM_Pacman/09\ -\ Data\ after\ cleaning/${strSess}/mp2rage/04_seg"
#
## Create directory (if it does not exist yet):
## mkdir -p ${strTrgRegAnat}  -- not necessary because already created in
##                               previous step
#
## cd into segmentation directory:
#cd ${strSrcRegAnat}
#
## Get file name of most recent segmentation
#strRcntSeg=$( ls | grep "${strSess}_mp2rage_seg_v[0-9][0-9].nii.gz" | tail -1 )
#
## Copy data to server using rsync:
#echo "sudo rsync -a -v -c ${strSrcRegAnat}${strRcntSeg} ${strTrgRegAnat}/"
## sudo rsync -a -v -c "${strSrcRegAnat}${strRcntSeg} ${strTrgRegAnat}/"
##------------------------------------------------------------------------------
