"""Utility functions."""

# Part of the Segmentator library
# See https://github.com/ofgulban/segmentator/tree/devel/segmentator/utils.py
# Copyright (C) 2016  Omer Faruk Gulban and Marian Schneider
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

import numpy as np
import nibabel as nb


def fncLoadNii(strPathIn):
    """
    Load nii file.
    
    Parameters
    ----------
    strPathIn : str
        Path to nifti file to load.

    Returns
    -------
    aryNii : np.array
        Array containing nii data.
    objHdr : header object
        Header of nii file.
    aryAff : np.array
        Array containing 'affine', i.e. information about spatial positioning
        of nii data.
    """
    # print(('------Loading: ' + strPathIn))
    # Load nii file (this doesn't load the data into memory yet):
    objNii = nb.load(strPathIn)
    # Load data into array:
    aryNii = objNii.get_data()
    # Get headers:
    objHdr = objNii.header
    # Get 'affine':
    aryAff = objNii.affine
    # Output nii data as numpy array and header:
    return aryNii, objHdr, aryAff

