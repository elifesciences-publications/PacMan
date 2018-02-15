#!/bin/sh

################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################

# Analysis parent directory:
strPathPrnt="/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/"

echo "-ParCon Analysis Pipleline --- 20180118"
date




echo "---Automatic: Copy input files for SPM bias field correction."
source ${strPathPrnt}06_mp2rage/n_01_prepare_spm_bf_correction.sh
date

echo "---Automatic: SPM bias field correction."
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/06_mp2rage/n_02_spm_bf_correction.m');"
date

echo "---Automatic: Copy results of SPM bias field correction, and remove"
echo "   redundant files."
source ${strPathPrnt}06_mp2rage/n_03_postprocess_spm_bf_correction.sh
date

echo "---Manual:"
cat ${strPathPrnt}06_mp2rage/n_04a_info_brainmask.txt
echo " "
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'
date

echo "---Automatic: Upsample combined mean for MP2RAGE registration."
source ${strPathPrnt}06_mp2rage/n_05_upsample_mean_epi.sh
date

echo "---Automatic: Prepare MP2RAGE to combined mean registration pipeline."
source ${strPathPrnt}06_mp2rage/n_06_sh_prepare_reg.sh
date

echo "---Automatic: Register MP2RAGE image to mean EPI"
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/06_mp2rage/n_07_spm_create_corr_batch_prereg.m');"
date

echo "---Automatic: Postprocess SPM registration results."
source ${strPathPrnt}06_mp2rage/n_08_sh_postprocess_spm_prereg.sh
date

echo "---Automatic: Prepare BBR."
python ${strPathPrnt}06_mp2rage/n_09_py_prepare_bbr.py
date

echo "---Automatic: Perform BBR."
source ${strPathPrnt}06_mp2rage/n_10_sh_bbr.sh
date

echo "---Automatic: Copy BBR results for segmentation."
source ${strPathPrnt}06_mp2rage/n_11_copy.sh
date

echo "---Manual:"
echo "   (1) Tissue type segmentation."
echo "   (2) Cortical depth sampling."

echo "-Done"
