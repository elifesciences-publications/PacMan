# -*- coding: utf-8 -*-
"""Calcualte overlap between PacMan stimulus and population receptive fields."""

# Part of py_pRF_motion library
# Copyright (C) 2017  Ingo Marquardt
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
import nibabel as nb
from utilities import fncLoadNii


# *** Parameters

# Path of input file containing pRF x-positions:
strPathPosX = '/home/john/Desktop/20150930_retinotopy/pRF_results_x_pos.nii'

# Path of input file containing pRF y-positions:
strPathPosY = '/home/john/Desktop/20150930_retinotopy/pRF_results_y_pos.nii'

# Path of input file containing pRF sizes:
strPathSd = '/home/john/Desktop/20150930_retinotopy/pRF_results_SD.nii'

# *** Load nii files:
aryPosX, objHdr, aryAff = fncLoadNii(strPathPosX)
aryPosY, _, _ = fncLoadNii(strPathPosY)
arySd, _, _ = fncLoadNii(strPathSd)


# 10 degrees size

# 70 degrees

