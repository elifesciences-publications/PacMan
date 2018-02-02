#!/bin/sh

# Create an alias:

alias mipavjava="/home/john/mipav/jre/bin/java -classpath /home/john/mipav/plugins/:/home/john/mipav/:`find /home/john/mipav/ -name \*.jar | sed 's#/home/john/mipav/#:/home/john/mipav/#' | tr -d '\n' | sed 's/^://'`"

# mipavjava edu.jhu.ece.iacl.jist.cli.runLayout /home/john/PhD/GitHub/PacMan/analysis/20171211_distcor_func/08_depthsampling/20171211_mp2rage_lh_equivol_retino_stats.LayoutXML --help

mipavjava edu.jhu.ece.iacl.jist.cli.runLayout \
/home/john/PhD/GitHub/PacMan/analysis/20171211_distcor_func/08_depthsampling/20171211_mp2rage_lh_equivol_retino_stats.LayoutXML \
-xRunOutOfProcess \
-xJreLoc /home/john/mipav/jre/bin/java \
-xDir /media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171211/cbs_distcor/lh \
-xClean
