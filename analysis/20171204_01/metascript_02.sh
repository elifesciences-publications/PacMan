#!/bin/bash


################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################


#-------------------------------------------------------------------------------
# ### Get data

# Analysis parent directory:
strPathPrnt="${pacman_anly_path}${pacman_sub_id}/"




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



