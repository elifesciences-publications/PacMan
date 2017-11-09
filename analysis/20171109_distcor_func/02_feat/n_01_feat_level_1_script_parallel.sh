#!/bin/sh

str_path="/home/john/PhD/GitHub/PacMan/analysis/20171109_distcor_func/02_feat/level_1_fsf/"

echo "-----------First level feat:-----------"

echo "---Main experimental runs"

date

feat "${str_path}feat_level_1_func_01.fsf" &
feat "${str_path}feat_level_1_func_02.fsf" &
feat "${str_path}feat_level_1_func_03.fsf" &
feat "${str_path}feat_level_1_func_04.fsf" &
feat "${str_path}feat_level_1_func_05.fsf" &
feat "${str_path}feat_level_1_func_06.fsf" &
feat "${str_path}feat_level_1_func_08.fsf" &
feat "${str_path}feat_level_1_func_09.fsf" &
wait

date

echo "---pRF mapping run (preprocessing only)"

feat "${str_path}feat_level_1_func_07.fsf"

date

echo "done"
