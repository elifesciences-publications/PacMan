#!/bin/sh

################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################

# Analysis parent directory:
strPathPrnt="/home/john/PhD/GitHub/PacMan/analysis/20171023_distcor_func/"

echo "-ParCon Analysis Pipleline --- 20171023"
date

echo "---Manual: Prepare directory tree using:"
echo "   > ~/01_preprocessing/n_01_sh_create_folders.sh"
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'

echo "---Manual: DICOM to nii conversion using:"
echo "   > ~/01_preprocessing/n_02_sh_dcm2nii"
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'

echo "---Manual: Adjust file names in n_03_sh_reorient.sh so that functional"
echo "   and anatomical data is renamed correctly."
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'
date

echo "---Automatic: Reorient & rename images:"
echo "   > ~/01_preprocessing/n_03_sh_reorient.sh"
source ${strPathPrnt}01_preprocessing/n_03_sh_reorient.sh
date

echo "---Automatic: Reverse order of opposite PE images"
echo "   > ~/01_preprocessing/n_04_inverse_order_func_op"
python ${strPathPrnt}01_preprocessing/n_04_py_inverse_order_func_op.py
date

echo "---Automatic: Prepare moco of SE EPI images"
echo "   > ~/01_preprocessing/n_05b_sh_fsl_preprocessing_1"
source ${strPathPrnt}01_preprocessing/n_05a_sh_prepare_moco.sh
source ${strPathPrnt}01_preprocessing/n_05b_sh_prepare_moco.sh
date

echo "---Automatic: Prepare moco"
echo "   > ~/01_preprocessing/n_05a_sh_fsl_preprocessing"
source ${strPathPrnt}01_preprocessing/n_05c_sh_prepare_moco.sh
date

echo "---Manual: Prepare reference weights for motion correction of functional"
echo "   data and opposite-phase polarity data (based on SE EPI images, i.e."
echo "   ~/func_se/func_00 and ~/func_se_op/func_00) and place them at:"
echo "   ~/nii_distcor/spm_reg/ref_weighting/"
echo "   and"
echo "   ~/nii_distcor/spm_reg_op/ref_weighting/"
echo "   in UNCOMPRESSED nii format."
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'
date

echo "---Automatic: Run SPM motion correction on functional data"
echo "   > ~/01_preprocessing/n_06a_spm_create_moco_batch.m"
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20171023_distcor_func/01_preprocessing/n_06a_spm_create_moco_batch.m');"
date

echo "---Automatic: Run SPM motion correction on opposite-phase polarity data"
echo "   > ~/01_preprocessing/n_06c_spm_create_moco_batch_op.m"
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20171023_distcor_func/01_preprocessing/n_06c_spm_create_moco_batch_op.m');"
date

echo "---Automatic: Copy moco results"
echo "   > ~/01_preprocessing/n_07a_sh_postprocess_moco.sh"
source ${strPathPrnt}01_preprocessing/n_07a_sh_postprocess_moco.sh
date

echo "---Automatic: Copy moco results of SE EPI images"
echo "   > ~/01_preprocessing/n_07b_sh_postprocess_moco.sh"
source ${strPathPrnt}01_preprocessing/n_07b_sh_postprocess_moco.sh
date

echo "---Automatic: Copy moco results of opposite-phase polarity SE EPI images"
echo "   > ~/01_preprocessing/n_07c_sh_postprocess_moco.sh"
source ${strPathPrnt}01_preprocessing/n_07c_sh_postprocess_moco.sh
date

#echo "---Manual: Check the following:"
#echo "   (1) Is the information about phase-encoding in the files"
#echo "           n_08c_datain_topup.txt"
#echo "       &"
#echo "           n_09c_datain_applytopup.txt"
#echo "       correct?"
#echo "   Type 'go' to continue"
#read -r -s -d $'g'
#read -r -s -d $'o'
#echo "   (2) Do the files"
#echo "           n_08a_sh_fsl_topup.s"
#echo "       &"
#echo "           n_09a_fsl_applytopup.sh"
#echo "       refer to those two above mentioned text files?"
#echo "   Type 'go' to continue"
#read -r -s -d $'g'
#read -r -s -d $'o'

echo "---Automatic: Calculate fieldmaps"
echo "   > ~/01_preprocessing/n_08a_sh_fsl_topup.sh"
source ${strPathPrnt}01_preprocessing/n_08a_sh_fsl_topup.sh
date

echo "---Automatic: Apply TOPUP on functional data"
echo "   > ~/01_preprocessing/n_09a_fsl_applytopup.sh"
source ${strPathPrnt}01_preprocessing/n_09a_fsl_applytopup.sh
date

echo "---Automatic: Apply TOPUP on SE EPI data"
echo "   > ~/01_preprocessing/n_09b_fsl_applytopup.sh"
source ${strPathPrnt}01_preprocessing/n_09b_fsl_applytopup.sh
date

echo "---Automatic: Create mean undistorted SE EPI image."
echo "   > ~/01_preprocessing/n_10_sh_mean_se.sh"
source ${strPathPrnt}01_preprocessing/n_10_sh_mean_se.sh
date

###############################################################################
# In session 20171023, the last rest block of every functional run was        #
# skipped because of a bug. The purpose of this script is to remove the last  #
# 10 volumes corresponding to the last rest block from the timeseries.        #
###############################################################################
echo "---Automatic: Remove volumes corresponding to missing REST condition."
echo "   > ~/01_preprocessing/n_11_sh_remove_last_rest.sh"
source ${strPathPrnt}01_preprocessing/n_11_sh_remove_last_rest.sh
date

echo "---Automatic: 1st level FSL FEAT with sustained predictors."
echo "   > ~/01_preprocessing/n_01_feat_level_1_script_parallel.sh"
source ${strPathPrnt}02_feat/n_01_feat_level_1_script_parallel.sh
date

echo "---Automatic: 1st level FSL FEAT with transient predictors."
echo "   > ~/01_preprocessing/n_02_feat_level_1_script_parallel_trans.sh"
source ${strPathPrnt}02_feat/n_02_feat_level_1_script_parallel_trans.sh
date

echo "---Automatic: Calculate tSNR maps."
echo "   > ~/03_intermediate_steps/n_01_sh_tSNR.sh"
source ${strPathPrnt}03_intermediate_steps/n_01_sh_tSNR.sh
date

echo "---Automatic: Update FEAT directories (dummy registration)."
echo "   > ~/03_intermediate_steps/n_02a_sh_fsl_updatefeatreg.sh"
source ${strPathPrnt}03_intermediate_steps/n_02a_sh_fsl_updatefeatreg.sh
date

echo "---Automatic: Update FEAT directories (dummy registration) for transient"
echo "   predictors."
echo "   > ~/03_intermediate_steps/n_02b_sh_fsl_updatefeatreg_trans.sh"
source ${strPathPrnt}03_intermediate_steps/n_02b_sh_fsl_updatefeatreg_trans.sh
date

echo "---Automatic: Create event related averages."
echo "   > ~/03_intermediate_steps/n_03a_py_evnt_rltd_avrgs.py"
python ${strPathPrnt}03_intermediate_steps/n_03a_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
echo "   > ~/03_intermediate_steps/n_03b_py_evnt_rltd_avrgs.py"
python ${strPathPrnt}03_intermediate_steps/n_03b_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
echo "   > ~/03_intermediate_steps/n_03c_py_evnt_rltd_avrgs.py"
python ${strPathPrnt}03_intermediate_steps/n_03c_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
echo "   > ~/03_intermediate_steps/n_03d_py_evnt_rltd_avrgs.py"
python ${strPathPrnt}03_intermediate_steps/n_03d_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Prepare depth-sampling of event related averages."
echo "   > ~/03_intermediate_steps/n_04_sh_prepare_era_depthsampling.sh"
source ${strPathPrnt}03_intermediate_steps/n_04_sh_prepare_era_depthsampling.sh
date

echo "---Automatic: Calculate spatial correlation."
echo "   > ~/03_intermediate_steps/n_12_py_spatial_correlation.py"
python ${strPathPrnt}03_intermediate_steps/n_12_py_spatial_correlation.py
date

echo "---Automatic: 2nd level FSL FEAT with sustained predictors."
echo "   > ~/04_feat/n_01_feat_level_2.sh"
source ${strPathPrnt}04_feat/n_01_feat_level_2.sh
date

echo "---Automatic: 2nd level FSL FEAT with transient predictors."
echo "   > ~/04_feat/n_02_feat_level_2_trans.sh"
source ${strPathPrnt}04_feat/n_02_feat_level_2_trans.sh
date

echo "---Automatic: Copy FEAT results."
echo "   > ~/04_feat/n_0*_sh_fsl_copy_*.sh"
source ${strPathPrnt}05_postprocessing/n_01_sh_fsl_copy_stats.sh
source ${strPathPrnt}05_postprocessing/n_02_sh_fsl_copy_stats_trans.sh
source ${strPathPrnt}05_postprocessing/n_03_sh_fsl_copy_stats_pe.sh
source ${strPathPrnt}05_postprocessing/n_04_sh_fsl_copy_stats_pe_trans.sh
source ${strPathPrnt}05_postprocessing/n_05_sh_fsl_copy_mean.sh
source ${strPathPrnt}05_postprocessing/n_06_sh_fsl_copy_mean_trans.sh
date

echo "---Automatic: Upsample FEAT results."
echo "   > ~/05_postprocessing/n_07_upsample_stats.sh"
source ${strPathPrnt}05_postprocessing/n_07_upsample_stats.sh
echo "   > ~/05_postprocessing/n_08_upsample_stats_trans.sh"
source ${strPathPrnt}05_postprocessing/n_08_upsample_stats_trans.sh
date

echo "---Automatic: Prepare pRF analysis."
echo "   > ~/07_pRF/01_py_prepare_prf.py"
python ${strPathPrnt}07_pRF/01_py_prepare_prf.py
date

echo "---Automatic: Activate py_devel virtual environment for pRF analysis."
source activate py_devel
date

echo "---Automatic: Perform pRF analysis with pyprf"
pyprf -config ${strPathPrnt}07_pRF/02_pRF_config_volumesmoothing.csv
date

echo "---Automatic: Activate default python environment (py_main)."
source activate py_main
date

echo "---Automatic: Upsample pRF results."
echo "   > ~/07_pRF/03_upsample_retinotopy.sh"
source ${strPathPrnt}07_pRF/03_upsample_retinotopy.sh
date

echo "---Automatic: Calculate overlap between voxel pRFs and stimulus."
echo "   > ~/07_pRF/04_PacMan_pRF_overlap.py"
python ${strPathPrnt}07_pRF/04_PacMan_pRF_overlap.py
date

echo "---Automatic: Copy input files for SPM bias field correction."
echo "   > ~/06_mp2rage/n_01_prepare_spm_bf_correction.sh"
source ${strPathPrnt}06_mp2rage/n_01_prepare_spm_bf_correction.sh
date

echo "---Manual: Create and run SPM bias field correction batch."
echo "   > ~/06_mp2rage/n_01_sh_create_folders.sh"
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'
date

echo "---Automatic: Copy results of SPM bias field correction, and remove"
echo "   redundant files."
echo "   > ~/06_mp2rage/n_03_postprocess_spm_bf_correction.sh"
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
echo "   > ~/06_mp2rage/n_05_upsample_mean_epi.sh"
source ${strPathPrnt}06_mp2rage/n_05_upsample_mean_epi.sh
date

echo "---Automatic: Prepare MP2RAGE to combined mean registration pipeline."
echo "   > ~/06_mp2rage/n_06_sh_prepare_reg.sh"
source ${strPathPrnt}06_mp2rage/n_06_sh_prepare_reg.sh
date

echo "---Automatic: Register MP2RAGE image to mean EPI"
echo "   > ~/06_mp2rage/n_07_spm_create_corr_batch_prereg.m"
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20171023_distcor_func/06_mp2rage/n_07_spm_create_corr_batch_prereg.m');"
date

echo "---Automatic: Postprocess SPM registration results."
echo "   > ~/06_mp2rage/n_08_sh_postprocess_spm_prereg.sh"
source ${strPathPrnt}06_mp2rage/n_08_sh_postprocess_spm_prereg.sh
date

echo "---Automatic: Prepare BBR."
echo "   > ~/06_mp2rage/n_09_py_prepare_bbr.py"
python ${strPathPrnt}06_mp2rage/n_09_py_prepare_bbr.py
date

echo "---Automatic: Perform BBR."
echo "   > ~/06_mp2rage/n_10_sh_bbr.sh"
source ${strPathPrnt}06_mp2rage/n_10_sh_bbr.sh
date

echo "---Automatic: Copy BBR results for segmentation."
echo "   > ~/06_mp2rage/n_11_copy.sh"
source ${strPathPrnt}06_mp2rage/n_11_copy.sh
date

echo "---Manual:"
echo "   (1) Tissue type segmentation."
echo "   (2) Cortical depth sampling."

echo "-Done"
