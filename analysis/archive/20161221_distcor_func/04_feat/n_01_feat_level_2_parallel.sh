#!/bin/sh


echo "-----------2nd level feat-----------"


str_path="/home/john/PhD/GitHub/PacMan/20161221_distcor_func/04_feat/level_2_fsf/"


date
feat "${str_path}feat_level_2_PacMan_Dynamic.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_minus_Static.fsf" &
feat "${str_path}feat_level_2_PacMan_Static.fsf" &
feat "${str_path}feat_level_2_PacMan_Target.fsf" &
wait
date

echo "done"

