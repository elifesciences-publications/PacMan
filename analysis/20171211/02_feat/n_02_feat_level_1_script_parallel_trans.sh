#!/bin/sh

str_path="/home/john/PhD/GitHub/PacMan/analysis/20171211_distcor_func/02_feat/level_1_fsf_trans/"

echo "-----------First level feat:-----------"

echo "---Runs 01, 02, 03"

date
feat "${str_path}feat_level_1_func_01.fsf" &
feat "${str_path}feat_level_1_func_02.fsf" &
feat "${str_path}feat_level_1_func_03.fsf" &
wait

echo "---Runs 04, 05, 06, 08"

date
feat "${str_path}feat_level_1_func_04.fsf" &
feat "${str_path}feat_level_1_func_05.fsf" &
feat "${str_path}feat_level_1_func_06.fsf" &
feat "${str_path}feat_level_1_func_08.fsf" &
wait

date

echo "done"
