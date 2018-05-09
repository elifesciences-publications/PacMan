#!/bin/bash


################################################################################
# Metascript for the ParMan analysis pipeline.                                 #
################################################################################


# Analysis parent directory:
strPathPrnt="${pacman_anly_path}${pacman_sub_id}/"


#-------------------------------------------------------------------------------
# ### Second level FEAT

echo "---Automatic: 2nd level FSL FEAT."
source ${strPathPrnt}04_feat/n_01_feat_level_2.sh
date
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ### Postprocessing

echo "---Automatic: Copy FEAT results."
source ${strPathPrnt}05_postprocessing/n_01_sh_fsl_copy_zstat_sst.sh
source ${strPathPrnt}05_postprocessing/n_02_sh_fsl_copy_zstat_tran.sh
source ${strPathPrnt}05_postprocessing/n_03_sh_fsl_copy_zstat_comb.sh
source ${strPathPrnt}05_postprocessing/n_04_sh_fsl_copy_pe_sst.sh
source ${strPathPrnt}05_postprocessing/n_05_sh_fsl_copy_pe_tran.sh
source ${strPathPrnt}05_postprocessing/n_06_sh_fsl_copy_pe_comb.sh
source ${strPathPrnt}05_postprocessing/n_08_sh_fsl_copy_mean.sh
source ${strPathPrnt}05_postprocessing/n_09_sh_fsl_copy_mean_trans.sh
source ${strPathPrnt}05_postprocessing/n_10_sh_fsl_copy_mean_comb.sh
date

echo "---Automatic: Upsample FEAT results."
source ${strPathPrnt}05_postprocessing/n_11_upsample_stats.sh
source ${strPathPrnt}05_postprocessing/n_12_upsample_stats_trans.sh
source ${strPathPrnt}05_postprocessing/n_13_upsample_stats_comb.sh
date
#-------------------------------------------------------------------------------


