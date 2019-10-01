#!/bin/sh


###############################################################################
# Docker images to the  research data management server.                      #
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
# strPri="DM0412_IM_Pacman_P"

# Source directory:
strSrcDckr="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/Docker_Metadata/"

# Target directory:
strTrgDckr="${strMnt}/${strPub}/05-Specific_software/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Preparations

# Mount the server:
# sudo mount -t cifs ${strTrgt} ${strMnt} -o username=ingo.marquardt

# Change owner & group (probably because the server is using a windows file
# system this does not work):
# sudo chown -R john ./smb_research_data/
# sudo chgrp -R john ./smb_research_data/
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy Docker images

echo "Copy Docker images"
sudo rsync -a -v -c ${strSrcDckr} ${strTrgDckr}
#------------------------------------------------------------------------------
