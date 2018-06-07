# -*- coding: utf-8 -*-
"""
Read experiment log files and evaluate behavioural performance.

Experiment log files are read, and subjects' behavioural performance on
central fixation task is evaluated.
"""

# Part of PacMan analysis library
# Copyright (C) 2018  Ingo Marquardt
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.


import numpy as np
from load_csv_log import load_csv_log


# *****************************************************************************
# *** Define parameters

# Meta-condition (within or outside of retinotopic stimulus area):
lstMetaCon = ['stimulus', 'periphery']

# Region of interest ('v1' or 'v2'):
lstRoi = ['v1', 'v2', 'v3']

# Hemispheres ('lh' or 'rh'):
lstHmsph = ['lh', 'rh']

# List of subject identifiers:
lstSubIds = ['20171023',  # '20171109',
             '20171204_01',
             '20171204_02',
             '20171211',
             '20171213',
             '20180111',
             '20180118']

# Condition levels (used to complete file names) - nested list:
lstNstCon = [['Pd_sst', 'Cd_sst', 'Ps_sst'],
             ['Pd_min_Ps_sst'],
             ['Pd_min_Cd_sst'],
             ['Linear_sst'],
             ['Pd_trn', 'Cd_trn', 'Ps_trn'],
             ['Pd_min_Ps_trn'],
             ['Pd_min_Cd_trn'],
             ['Linear_trn']]

# Condition labels:
lstNstConLbl = [['PacMan Dynamic Sustained',
                 'Control Dynamic Sustained',
                 'PacMan Static Sustained'],
                ['PacMan D - PacMan S (Sustained)'],
                ['PacMan D - Control D (Sustained)'],
                ['Linear (Sustained)'],
                ['PacMan Dynamic Transient',
                 'Control Dynamic Transient',
                 'PacMan Static Transient'],
                ['PacMan D - PacMan S (Transient)'],
                ['PacMan D - Control D (Transient)'],
                ['Linear (Transient)']]

# Base path of vtk files with depth-sampled data, e.g. parameter estimates
# (with subject ID, hemisphere, and stimulus level left open):
strVtkDpth01 = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/{}/cbs/{}/feat_level_2_{}_cope.vtk'  #noqa

# (1)
# Restrict vertex selection to region of interest (ROI)?
lgcSlct01 = True
# Base path of csv files with ROI definition (i.e. patch of cortex selected on
# the surface, e.g. V1 or V2) - i.e. the first vertex selection criterion (with
# subject ID, hemisphere, and ROI left open):
# NOTE: The '_mod' subscript indicates that the csv files have been processed
# by the funtion `py_depthsampling.misc.fix_roi_csv.fix_roi_csv` in order to
# ensure that the indices of the ROI definition and the vtk meshes are
# congruent.
strCsvRoi = '/home/john/PhD/GitHub/PacMan/analysis/{}/08_depthsampling/{}/{}_mod.csv'  #noqa
# Number of header lines in ROI CSV file:
varNumHdrRoi = 1

# (2)
# Use vertex selection criterion 2 (vertices that are BELOW threshold are
# excluded - median across depth levels):
lgcSlct02 = True
# Path of vtk files with for vertex selection criterion. This vtk file is
# supposed to contain one set of data values for each depth level. (With
# subject ID and hemisphere left open.)
strVtkSlct02 = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/{}/cbs/{}/pRF_results_R2.vtk'  #noqa
# Threshold for vertex selection:
varThrSlct02 = 0.15

# (3)
# Use vertex selection criterion 3 (vertices that are BELOW threshold are
# excluded - minimum across depth levels):
lgcSlct03 = True
# Path of vtk files with for vertex selection criterion. This vtk file is
# supposed to contain one set of data values for each depth level. (With
# subject ID and hemisphere left open.)
strVtkSlct03 = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/{}/cbs/{}/combined_mean.vtk'  #noqa
# Threshold for vertex selection:
varThrSlct03 = 7000.0

# (4)
# Use vertex selection criterion 4 (vertices that are WITHIN INTERVAL are
# included - median across depth levels):
lgcSlct04 = True
# Path of vtk files with for vertex selection criterion. This vtk file is
# supposed to contain one set of data values for each depth level. (With
# subject ID and hemisphere left open.)
strVtkSlct04 = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/{}/cbs/{}/pRF_results_eccentricity.vtk'  #noqa
# Threshold for vertex selection - list of tuples (interval per meta-condition,
# e.g. within & outside stimulus area):
lstThrSlct04 = [(0.0, 3.0), (3.5, 4.0)]

# Number of cortical depths:
varNumDpth = 11

# Beginning of string which precedes vertex data in data vtk files (i.e. in the
# statistical maps):
strPrcdData = 'SCALARS'

# Number of lines between vertex-identification-string and first data point:
varNumLne = 2

# Label for axes:
strXlabel = 'Cortical depth level (equivolume)'
strYlabel = 'fMRI signal [a.u.]'

# Output path for plots - prefix:
strPltOtPre = '/home/john/PhD/PacMan_Plots/pe/{}/plots_{}/'

# Output path for plots - suffix:
strPltOtSuf = '_{}_{}_{}.png'

# Figure scaling factor:
varDpi = 80.0

# If normalisation - data from which input file to divide by?
# (Indexing starts at zero.) Note: This functionality is not used at the
# moment. Instead of dividing by a reference condition, all profiles are
# divided by the grand mean within subjects before averaging across subjects
# (if lgcNormDiv is true).
varNormIdx = 0

# Normalise by division?
lgcNormDiv = False

# Output path for depth samling results (within subject means):
strDpthMeans = '/home/john/PhD/PacMan_Depth_Data/Higher_Level_Analysis/{}/{}_{}_{}.npy'  #noqa

# Maximum number of processes to run in parallel: *** NOT IMPLEMENTED
# varPar = 10
# *****************************************************************************
