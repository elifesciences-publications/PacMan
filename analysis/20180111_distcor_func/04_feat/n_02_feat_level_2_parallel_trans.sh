#!/bin/sh

str_path="/home/john/PhD/GitHub/PacMan/analysis/20180111_distcor_func/04_feat/level_2_fsf_trans/"

echo "-----------Second level feat:-----------"

date

feat "${str_path}feat_level_2_Control_Dynamic.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_minus_Control_Dynamic.fsf" &
feat "${str_path}feat_level_2_PacMan_Static.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_minus_PacMan_Static.fsf" &
wait

date

echo "done"

