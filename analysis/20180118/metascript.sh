#!/bin/sh


################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################


#-------------------------------------------------------------------------------
# ### Define paths

# Subject ID:
pacman_sub_id="20180118"

# BIDS subject ID:
pacman_sub_id_bids="sub-09"

# Analysis parent directory (containing scripts):
pacman_anly_path="/home/john/PhD/GitHub/PacMan/analysis/"

# Data parent directory (containing MRI data). If working with the BIDS data,
# this data should be placed here (i.e. this folder should contain a folder
# called 'BIDS', which in turn contains the subject directories, such as
# '~/BIDS/sub-01/...').
pacman_data_path="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/"

# Whether to load data from BIDS structure. If 'true', data is loaded from BIDS
# structure. If 'false', DICOM data is converted into BIDS-compatible nii first.
pacman_from_bids=false
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Export paths

# Export paths so that all other scripts can use them.
export pacman_sub_id
export pacman_sub_id_bids
export pacman_anly_path
export pacman_data_path
export pacman_from_bids
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### Activate docker image

# Run dockerfrom image with shared folders (analysis folder is read-only).
# Environmental variables are passed in with the '-e' flag.
docker run -it --rm \
    -v ${strPathData}:${strPathData} \
    -v ${strPathAnly}:${strPathAnly}:ro \
    -e pacman_sub_id \
    -e pacman_sub_id_bids \
    -e pacman_anly_path \
    -e pacman_data_path \
    -e pacman_from_bids \
    dockerimage_pacman_01 bash
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Analysis

# Analysis parent directory:
strPathPrnt="${pacman_anly_path}${pacman_sub_id}/"

echo "-PacMan Analysis Pipleline --- ${pacman_sub_id}"
date

echo "---Automatic: Prepare directory tree using:"
source ${strPathPrnt}/00_get_data/n_01_sh_create_folders.sh

if ${pacman_from_bids};
then
	echo "---Skipping DICOM to nii conversion (will look for BIDS data)."
else
	echo "---Automatic: DICOM to nii conversion."
	source ${strPathPrnt}/00_get_data/n_02_sh_dcm2nii.sh
fi

if ${pacman_from_bids};
then
	:
else
	echo "---Automatic: Export nii to bids."
	source ${strPathPrnt}/00_get_data/n_03_sh_export_nii_to_bids.sh
fi

if ${pacman_from_bids};
then
	:
else
	echo "---Automatic: Export json metadata to bids."
	source ${strPathPrnt}/00_get_data/n_04_sh_export_json_to_bids.sh
fi

if ${pacman_from_bids};
then
	:
else
	echo "---Automatic: Deface nii data in bids folder."
	source ${strPathPrnt}/00_get_data/n_05_py_deface.sh
fi



echo "---Automatic: DICOM to nii conversion using:"




echo "---Automatic: Reorient & rename images:"
source ${strPathPrnt}01_preprocessing/n_03_sh_reorient.sh
date

echo "---Automatic: Reverse order of opposite PE images"
python ${strPathPrnt}01_preprocessing/n_04_py_inverse_order_func_op.py
date

echo "---Automatic: Prepare moco of SE EPI images"
source ${strPathPrnt}01_preprocessing/n_05a_sh_prepare_moco.sh
source ${strPathPrnt}01_preprocessing/n_05b_sh_prepare_moco.sh
date

echo "---Automatic: Prepare moco"
source ${strPathPrnt}01_preprocessing/n_05c_sh_prepare_moco.sh
date

echo "---Manual: Prepare reference weights for motion correction of functional"
echo "   data and opposite-phase polarity data (based on SE EPI images, i.e."
echo "   ~/func_se/func_00 and ~/func_se_op/func_00) and place them at:"
echo "   ~/nii/spm_reg/ref_weighting/"
echo "   and"
echo "   ~/nii/spm_reg_op/ref_weighting/"
echo "   in UNCOMPRESSED nii format."
echo "   Type 'go' to continue"
read -r -s -d $'g'
read -r -s -d $'o'
date

echo "---Automatic: Run SPM motion correction on functional data"
# matlab -nodisplay -nojvm -nosplash -nodesktop \
#   -r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/01_preprocessing/n_06a_spm_create_moco_batch.m');"
/opt/spm12/run_spm12.sh /opt/mcr/v92/ batch /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20180118/TMP_SCRIPTS_FOR_DOCKER/01_preprocessing/n_06a_spm_create_moco_batch.m
date

echo "---Automatic: Run SPM motion correction on opposite-phase polarity data"
matlab -nodisplay -nojvm -nosplash -nodesktop \
  -r "run('/home/john/PhD/GitHub/PacMan/analysis/20180118_distcor_func/01_preprocessing/n_06c_spm_create_moco_batch_op.m');"
date

echo "---Automatic: Copy moco results"
source ${strPathPrnt}01_preprocessing/n_07a_sh_postprocess_moco.sh
date

echo "---Automatic: Copy moco results of SE EPI images"
source ${strPathPrnt}01_preprocessing/n_07b_sh_postprocess_moco.sh
date

echo "---Automatic: Copy moco results of opposite-phase polarity SE EPI images"
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
source ${strPathPrnt}01_preprocessing/n_08a_sh_fsl_topup.sh
date

echo "---Automatic: Apply TOPUP on functional data"
source ${strPathPrnt}01_preprocessing/n_09a_fsl_applytopup.sh
date

echo "---Automatic: Apply TOPUP on SE EPI data"
source ${strPathPrnt}01_preprocessing/n_09b_fsl_applytopup.sh
date

echo "---Automatic: Create mean undistorted SE EPI image."
source ${strPathPrnt}01_preprocessing/n_10_sh_mean_se.sh
date

echo "---Automatic: 1st level FSL FEAT with sustained predictors."
source ${strPathPrnt}02_feat/n_01_feat_level_1_script_parallel.sh
date

echo "---Automatic: 1st level FSL FEAT with transient predictors."
source ${strPathPrnt}02_feat/n_02_feat_level_1_script_parallel_trans.sh
date

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

echo "---Automatic: 2nd level FSL FEAT with sustained predictors."
source ${strPathPrnt}04_feat/n_01_feat_level_2.sh
date

echo "---Automatic: 2nd level FSL FEAT with transient predictors."
source ${strPathPrnt}04_feat/n_02_feat_level_2_trans.sh
date

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

echo "---Automatic: Prepare pRF analysis."
python ${strPathPrnt}07_pRF/01_py_prepare_prf.py
date

echo "---Automatic: Activate py2_pyprf virtual environment for pRF analysis."
source activate py2_pyprf
date

echo "---Automatic: Perform pRF analysis with pyprf"
pyprf -config ${strPathPrnt}07_pRF/02_pRF_config_volumesmoothing.csv
date

echo "---Automatic: Activate default python environment (py_main)."
source activate py_main
date

echo "---Automatic: Upsample pRF results."
source ${strPathPrnt}07_pRF/03_upsample_retinotopy.sh
date

echo "---Automatic: Calculate overlap between voxel pRFs and stimulus."
python ${strPathPrnt}07_pRF/04_PacMan_pRF_overlap.py
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
