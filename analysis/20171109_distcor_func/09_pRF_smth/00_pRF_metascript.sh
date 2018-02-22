#!/bin/sh

################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################

# Analysis parent directory:
strPathPrnt="/home/john/PhD/GitHub/PacMan/analysis/20171109_distcor_func/"

echo "-ParCon pRF Pipleline --- 20171109"
date

echo "---Automatic: Prepare pRF analysis."
python ${strPathPrnt}09_pRF_smth/01_py_prepare_prf.py
date

echo "---Automatic: Activate py_devel virtual environment for pRF analysis."
source activate py_devel
date

echo "---Automatic: Perform pRF analysis with pyprf"
pyprf -config ${strPathPrnt}09_pRF_smth/02_pRF_config_volumesmoothing.csv
date

echo "---Automatic: Activate default python environment (py_main)."
source activate py_main
date

echo "---Automatic: Upsample pRF results."
source ${strPathPrnt}09_pRF_smth/03_upsample_retinotopy.sh
date

echo "---Automatic: Calculate overlap between voxel pRFs and stimulus."
python ${strPathPrnt}09_pRF_smth/04_PacMan_pRF_overlap.py
date

echo "-Done"
