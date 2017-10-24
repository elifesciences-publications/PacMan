#!/bin/sh


################################################################################
# Run 2nd level feat with reduced number of runs, in order to test how stable  #
# the results are with less data.                                              #
################################################################################


echo "-----------2nd level feat-----------"


str_path="/home/john/PhD/GitHub/PacMan/20161221_distcor_func/04_feat/level_2_fsf_reduced/"


date
feat "${str_path}feat_level_2_PacMan_Dynamic_02.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_03.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_04.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_05.fsf" &
wait
date

echo "done"

