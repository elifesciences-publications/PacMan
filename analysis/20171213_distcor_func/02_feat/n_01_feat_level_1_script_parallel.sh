#!/bin/sh

str_path="/home/john/PhD/GitHub/PacMan/analysis/20171213_distcor_func/02_feat/level_1_fsf/"

echo "-----------First level feat:-----------"

echo "---Runs 01, 02, 03, 04, 05"

date

feat "${str_path}feat_level_1_func_01.fsf" &
feat "${str_path}feat_level_1_func_02.fsf" &
feat "${str_path}feat_level_1_func_03.fsf" &
feat "${str_path}feat_level_1_func_04.fsf" &
feat "${str_path}feat_level_1_func_05.fsf" &
wait

date

echo "---Runs 06, 07, 08"

feat "${str_path}feat_level_1_func_06.fsf" &
feat "${str_path}feat_level_1_func_07.fsf" &
feat "${str_path}feat_level_1_func_08.fsf" &
wait

date

echo "done"
