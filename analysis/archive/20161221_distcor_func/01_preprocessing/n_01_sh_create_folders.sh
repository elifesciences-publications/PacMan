#!/bin/sh


################################################################################
# The purpose of this script is to create a directory tree for the PacMan      #
# Experiment.                                                                  #
################################################################################


#-------------------------------------------------------------------------------
### Define parameters:

# Define session ID of the new session:
str_session_ID="19680801_distcor"

# Parent directory:
str_path_parent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${str_session_ID}"

# Functional runs (input):
ary_run_IDs=(func_01 \
             func_02 \
             func_03 \
             func_04 \
             func_05 \
             func_06 \
             func_07 \
             func_08 \
             func_09 \
             func_10)
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
### Create folders:

# Number of runs:
#var_include=${#ary_run_IDs[@]}

# Check whether the session directory already exists:
if [ ! -d "${str_path_parent}" ];
then
	echo "Creating directory tree for ${str_session_ID}"

	mkdir "${str_path_parent}"
	mkdir "${str_path_parent}/nii_distcor"

	mkdir "${str_path_parent}/nii_distcor/evc_cubes"
	mkdir "${str_path_parent}/nii_distcor/evc_cubes/for_feat"

	mkdir "${str_path_parent}/nii_distcor/feat_level_1"
	mkdir "${str_path_parent}/nii_distcor/feat_level_2"

	mkdir "${str_path_parent}/nii_distcor/func"
	mkdir "${str_path_parent}/nii_distcor/func_distcorField"
	mkdir "${str_path_parent}/nii_distcor/func_distcorUnwrp"
	mkdir "${str_path_parent}/nii_distcor/func_merged"
	mkdir "${str_path_parent}/nii_distcor/func_op"
	mkdir "${str_path_parent}/nii_distcor/func_op_inv"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_cube"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_cube_tSNR"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_cube_up"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_cube_up_tSNR"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_cube_denoise"
	mkdir "${str_path_parent}/nii_distcor/func_regAcrssRuns_tsnr"
	mkdir "${str_path_parent}/nii_distcor/func_regWithinRun"
	mkdir "${str_path_parent}/nii_distcor/func_regWithinRun_op"
	mkdir "${str_path_parent}/nii_distcor/func_roi"

	mkdir "${str_path_parent}/nii_distcor/mp2rage"

	mkdir "${str_path_parent}/nii_distcor/mp2rage/01_orig"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/02_pdw_brainmask"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/01_in"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/02_reorient2std"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/03_brainmask"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/04_biasfieldremoval"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/05_prereg"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/05_prereg/combined_mean"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/05_prereg/mp2rage_other"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/05_prereg/mp2rage_t1w"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/06_crop"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/07_reg"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/07_reg/01_in"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/07_reg/02_bbr_prep"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/07_reg/03_bbr"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/03_reg/07_reg/04_inv_bbr"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/04_seg"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/04_seg/01_native_space"
	mkdir "${str_path_parent}/nii_distcor/mp2rage/04_seg/02_up"

	mkdir "${str_path_parent}/nii_distcor/raw_data"

	mkdir "${str_path_parent}/nii_distcor/retinotopy"
	mkdir "${str_path_parent}/nii_distcor/retinotopy/mask"
	mkdir "${str_path_parent}/nii_distcor/retinotopy/pRF_results"
	mkdir "${str_path_parent}/nii_distcor/retinotopy/pRF_results_up"
	mkdir "${str_path_parent}/nii_distcor/retinotopy/pRF_stimuli"

	# Create subfolders for SPM - across runs moco:
	mkdir "${str_path_parent}/nii_distcor/spm_regAcrssRuns"
	mkdir "${str_path_parent}/nii_distcor/spm_regAcrssRuns/ref_weighting"
	for index_1 in ${ary_run_IDs[@]}
	do
		str_tmp_1="${str_path_parent}/nii_distcor/spm_regAcrssRuns/${index_1}"
		mkdir "${str_tmp_1}"
	done

	# Create subfolders for SPM - within runs moco:
	mkdir "${str_path_parent}/nii_distcor/spm_regWithinRun"
	for index_1 in ${ary_run_IDs[@]}
	do
		str_tmp_1="${str_path_parent}/nii_distcor/spm_regWithinRun/${index_1}"
		mkdir "${str_tmp_1}"

		str_tmp_2="${str_path_parent}/nii_distcor/spm_regWithinRun/${index_1}_ref_weighting"
		mkdir "${str_tmp_2}"
	done

	# Create subfolders for SPM - within runs opposite phase data moco:
	mkdir "${str_path_parent}/nii_distcor/spm_regWithinRun_op"
	for index_1 in ${ary_run_IDs[@]}
	do
		str_tmp_1="${str_path_parent}/nii_distcor/spm_regWithinRun_op/${index_1}"
		mkdir "${str_tmp_1}"

		str_tmp_2="${str_path_parent}/nii_distcor/spm_regWithinRun_op/${index_1}_ref_weighting"
		mkdir "${str_tmp_2}"
	done

	mkdir "${str_path_parent}/nii_distcor/spm_reg_reference_weighting"
	mkdir "${str_path_parent}/nii_distcor/spm_reg_moco_params"

	mkdir "${str_path_parent}/nii_distcor/stat_maps"
	mkdir "${str_path_parent}/nii_distcor/stat_maps_up"

	mkdir "${str_path_parent}/cbs_distcor"
	mkdir "${str_path_parent}/cbs_distcor/lh"
	mkdir "${str_path_parent}/cbs_distcor/results"
	mkdir "${str_path_parent}/cbs_distcor/rh"

else
	echo "Directory for ${str_session_ID} does already exist."
fi
#-------------------------------------------------------------------------------
