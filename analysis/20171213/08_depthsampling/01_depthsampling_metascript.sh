#!/bin/sh


# Copyright (C) 2018  Ingo Marquardt
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.


###############################################################################
# Depth sampling meta script. Perform depth sampling with CBS tools and post- #
# process results (file renaming and conversion of event-related time course  #
# vtk meshes to npy format).                                                  #
###############################################################################


#------------------------------------------------------------------------------
# ### Preparations

# Location of CBS layouts & python scripts to run:
strPthCbs="/home/john/PhD/GitHub/PacMan/analysis/20171213_distcor_func/08_depthsampling/"

# Names of CBS layouts to run (xml files):
aryCbs=(20171213_mp2rage_lh_equivol_retino_stats.LayoutXML \
        20171213_mp2rage_rh_equivol_retino_stats.LayoutXML
        20171213_mp2rage_lh_equivol_ert.LayoutXML \
        20171213_mp2rage_rh_equivol_ert.LayoutXML \
        20171213_mp2rage_lh_equivol_ert_long.LayoutXML \
        20171213_mp2rage_rh_equivol_ert_long.LayoutXML)

# Names of python scripts to run:
aryPy=(ds_renameJistOutput.py \
       ds_renameJistOutput_ert.py \
       ds_renameJistOutput_ert_long.py \
       py_37_postprocess_retinotopy_vtk_lh.py \
       py_37_postprocess_retinotopy_vtk_rh.py \
       py_vtk_to_npy_conversion.py)

# Working directory:
strPthWd="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171213/cbs_distcor/cbs_wd"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# ### Loop through CBS layouts

echo "-Depth sampling metascript"

# Create an alias for mipav:
alias mipavjava="/home/john/mipav/jre/bin/java -classpath \
/home/john/mipav/plugins/:/home/john/mipav/:`find /home/john/mipav/ -name \
\*.jar | sed 's#/home/john/mipav/#:/home/john/mipav/#' | tr -d '\n' | sed \
's/^://'`"

echo "--CBS depth sampling"

for idx01 in ${aryCbs[@]}
do
  # Create working directory:
  mkdir ${strPthWd}

  # Absolute path of current CBS layout:
  strPthCbsTmp=${strPthCbs}${idx01}

  echo "---Running CBS layout: ${strPthCbsTmp}"

  # Run CBS layout through mipav:
  mipavjava edu.jhu.ece.iacl.jist.cli.runLayout \
  ${strPthCbsTmp} \
  -xRunOutOfProcess \
  -xJreLoc /home/john/mipav/jre/bin/java \
  -xDir ${strPthWd} \
  -xClean

  # Remove working directory (results are copied to destination directory
  # within the CBS layout):
  rm -r ${strPthWd}
done
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# ### Loop through postprocessing python scripts

echo "--Postprocessing"

for idx02 in ${aryPy[@]}
do
  # Absolute path of current python script:
  strPyTmp=${strPthCbs}${idx02}

  echo "---Running: ${strPyTmp}"

  # Run the python script:
  python ${strPyTmp}
done
#------------------------------------------------------------------------------
