#!/bin/bash


################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################


#-------------------------------------------------------------------------------
# ### Get data

# Analysis parent directory:
strPathPrnt="${pacman_anly_path}${pacman_sub_id}/"




#-------------------------------------------------------------------------------
# ### First level FEAT

echo "---Automatic: 1st level FSL FEAT with sustained predictors."
source ${strPathPrnt}02_feat/n_01_feat_level_1_script_parallel.sh
date

echo "---Automatic: 1st level FSL FEAT with transient predictors."
source ${strPathPrnt}02_feat/n_02_feat_level_1_script_parallel_trans.sh
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### Intermediate steps


echo "---Automatic: Calculate tSNR maps."
source ${strPathPrnt}03_intermediate_steps/n_01_sh_tSNR.sh
date

echo "---Automatic: Update FEAT directories (dummy registration)."
source ${strPathPrnt}03_intermediate_steps/n_02a_sh_fsl_updatefeatreg.sh
date

echo "---Automatic: Update FEAT directories (dummy registration) for transient"
echo "   predictors."
source ${strPathPrnt}03_intermediate_steps/n_02b_sh_fsl_updatefeatreg_trans.sh
date

echo "---Automatic: Create event related averages."
python ${strPathPrnt}03_intermediate_steps/n_03a_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
python ${strPathPrnt}03_intermediate_steps/n_03b_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
python ${strPathPrnt}03_intermediate_steps/n_03c_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Create event related averages."
python ${strPathPrnt}03_intermediate_steps/n_03d_py_evnt_rltd_avrgs.py
date

echo "---Automatic: Prepare depth-sampling of event related averages."
source ${strPathPrnt}03_intermediate_steps/n_04_sh_prepare_era_depthsampling.sh
date

echo "---Automatic: Calculate spatial correlation."
python ${strPathPrnt}03_intermediate_steps/n_12_py_spatial_correlation.py
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### Second level FEAT

echo "---Automatic: 2nd level FSL FEAT with sustained predictors."
source ${strPathPrnt}04_feat/n_01_feat_level_2.sh
date

echo "---Automatic: 2nd level FSL FEAT with transient predictors."
source ${strPathPrnt}04_feat/n_02_feat_level_2_trans.sh
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### Postprocessing

echo "---Automatic: Copy FEAT results."
source ${strPathPrnt}05_postprocessing/n_01_sh_fsl_copy_stats.sh
source ${strPathPrnt}05_postprocessing/n_02_sh_fsl_copy_stats_trans.sh
source ${strPathPrnt}05_postprocessing/n_03_sh_fsl_copy_stats_pe.sh
source ${strPathPrnt}05_postprocessing/n_04_sh_fsl_copy_stats_pe_trans.sh
source ${strPathPrnt}05_postprocessing/n_05_sh_fsl_copy_mean.sh
source ${strPathPrnt}05_postprocessing/n_06_sh_fsl_copy_mean_trans.sh
date

echo "---Automatic: Upsample FEAT results."
source ${strPathPrnt}05_postprocessing/n_07_upsample_stats.sh
source ${strPathPrnt}05_postprocessing/n_08_upsample_stats_trans.sh
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### pRF analysis

echo "---Automatic: Prepare pRF analysis."
python ${strPathPrnt}07_pRF/01_py_prepare_prf.py
source ${strPathPrnt}07_pRF/02a_prepare_pRF_config.sh
date

echo "---Automatic: Perform pRF analysis with pyprf"
pyprf -config ${strPathPrnt}07_pRF/02b_pRF_config_sed.csv
date

echo "---Automatic: Upsample pRF results."
source ${strPathPrnt}07_pRF/03_upsample_retinotopy.sh
date

echo "---Automatic: Calculate overlap between voxel pRFs and stimulus."
python ${strPathPrnt}07_pRF/04_PacMan_pRF_overlap.py
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### MP2RAGE

echo "---Automatic: Copy input files for SPM bias field correction."
source ${strPathPrnt}06_mp2rage/n_01_prepare_spm_bf_correction.sh
date

echo "---Automatic: SPM bias field correction."
#matlab -nodisplay -nojvm -nosplash -nodesktop \
#	-r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/06_mp2rage/n_02_spm_bf_correction.m');"
/opt/spm12/run_spm12.sh /opt/mcr/v93/ batch ${pacman_anly_path}${pacman_sub_id}/06_mp2rage/n_02_spm_bf_correction.m
date

echo "---Automatic: Copy results of SPM bias field correction, and remove"
echo "   redundant files."
source ${strPathPrnt}06_mp2rage/n_03_postprocess_spm_bf_correction.sh
date

if ${pacman_wait};
then
	echo "---Manual:"
	cat ${strPathPrnt}06_mp2rage/n_04a_info_brainmask.txt
	echo " "
	echo "   Type 'go' to continue"
	read -r -s -d $'g'
	read -r -s -d $'o'
	date
else
	:
fi

# Copy brain mask into data directory:
cp ${pacman_anly_path}${pacman_sub_id}/06_mp2rage/n_04b_${pacman_sub_id}_pwd_brainmask.nii.gz \
   ${pacman_data_path}${pacman_sub_id}/nii/mp2rage/03_reg/02_brainmask/

echo "---Automatic: Upsample combined mean for MP2RAGE registration."
source ${strPathPrnt}06_mp2rage/n_05_upsample_mean_epi.sh
date

echo "---Automatic: Prepare MP2RAGE to combined mean registration pipeline."
source ${strPathPrnt}06_mp2rage/n_06_sh_prepare_reg.sh
date

echo "---Automatic: Register MP2RAGE image to mean EPI"
#matlab -nodisplay -nojvm -nosplash -nodesktop \
#	-r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/06_mp2rage/n_07_spm_create_corr_batch_prereg.m');"
/opt/spm12/run_spm12.sh /opt/mcr/v93/ batch ${pacman_anly_path}${pacman_sub_id}/06_mp2rage/n_07_spm_create_corr_batch_prereg.m
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
#-------------------------------------------------------------------------------
