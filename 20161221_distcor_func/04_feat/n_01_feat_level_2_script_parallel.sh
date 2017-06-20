#!/bin/sh


echo "-----------PART 2: 2nd level feat-----------"


str_path="/home/john/PhD/Analysis_Scripts/Analysis_Scripts_347_10012017/Miscellaneous/PacMan/20161221_distcor_func/04_feat/level_2_fsf/"


echo "2nd level feat"
date
feat "${str_path}feat_level_2_PacMan_Dynamic.fsf" &
feat "${str_path}feat_level_2_PacMan_Dynamic_minus_Static.fsf" &
feat "${str_path}feat_level_2_PacMan_Static.fsf" &
feat "${str_path}feat_level_2_PacMan_Target.fsf" &
wait
date
echo "done"


