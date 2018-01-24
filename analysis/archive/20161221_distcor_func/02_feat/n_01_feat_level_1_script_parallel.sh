#!/bin/sh

echo "-----------PART 1: 1st level feat:-----------"

str_path="/home/john/PhD/GitHub/PacMan/20161221_distcor_func/02_feat/level_1_fsf/"

echo "feat on runs 01 to 06"
date
feat "${str_path}feat_level_1_func_01.fsf" &
feat "${str_path}feat_level_1_func_02.fsf" &
feat "${str_path}feat_level_1_func_03.fsf" &
feat "${str_path}feat_level_1_func_04.fsf" &
feat "${str_path}feat_level_1_func_05.fsf" &
feat "${str_path}feat_level_1_func_06.fsf" &
feat "${str_path}feat_level_1_func_pRF.fsf" &
wait
date
echo "done"
