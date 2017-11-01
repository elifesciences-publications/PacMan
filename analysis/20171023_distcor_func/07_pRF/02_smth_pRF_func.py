# -*- coding: utf-8 -*-

"""Smoothing of functional data within grey matter mask."""

# Part of PacMan library
# Copyright (C) 2016  Ingo Marquardt
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
from utilities import load_nii
from utilities_segmentator import aniso_diff_3D


# *****************************************************************************
# *** Parameters

# Parent path of input data:
strPrnt = '/home/john/Desktop/tmp/'

# Path of functional runs to perform smoothing on (parent path left open):
lstFunc = ['{}retinotopy/func_prepro/filtered_func_up.nii']

varNumIn = len(lstFunc)

# List of grey matter masks to restrict smoothing (parent path left open):
lstMsk = ['{}mp2rage/04_seg/20171023_mp2rage_seg_v27.nii.gz']

# Value of grey matter within mask (smoothing will be restricted to these
# regions):
varMsk = 1

# Suffix for output files (will be saved in same directory as input files):
strSuff = '_aniso_smth_n3_k90_g0p2.nii.gz'


# *****************************************************************************
# *** Loop through input files

print('-Smoothing of functional data within grey matter mask.')

for idxIn in range(varNumIn):

    # *************************************************************************
    # *** Load nii data

    print('--Loading data')

    # Path of current nii file:
    strNiiTmp = lstFunc[idxIn].format(strPrnt)

    print(('---Loading functional data: ' + strNiiTmp))

    # Load nii:
    aryNii, objHdr, aryAff = load_nii(strNiiTmp)

    # Reduce precision:
    if type(aryNii[0, 0, 0, 0]) == np.float16:
        print('------Functional data is of type np.float16.')
    else:
        print(('------Converting functional data to type np.float16.'))
        aryNii = aryNii.astype(np.float16)

    # Output file name:
    strPthOut = strNiiTmp.split('.')[0] + strSuff

    # Path of GM mask:
    strNiiTmp = lstMsk[idxIn].format(strPrnt)

    print(('---Loading mask: ' + strNiiTmp))

    # Load nii:
    aryNiiMsk, _, _ = load_nii(strNiiTmp)

    # *************************************************************************
    # *** Apply mask

    print('--Applying mask')

    # Convert mask to integer:
    aryNiiMsk = aryNiiMsk.astype(np.int16)

    # Create binary mask for all voxels that are not GM:
    aryNiiMsk = np.not_equal(aryNiiMsk, int(varMsk))

    # In anisotropic smoothing, the mask restricts the smoothing through an
    # intensity gradient between values inside and outside the mask. We could
    # set all values outside the mask to zero; however, if some of the nii
    # data points have low intensities close to zero this may not properly
    # restrict the smoothing operation. Thus, we set the datapoints outside
    # the mask to a much lower value.
    aryNii[aryNiiMsk, :] = -10000.0

    # *************************************************************************
    # *** Prepare status indicator

    # Number of volumes (time points):
    varNumVol = aryNii.shape[3]

    varStsStpSze = 20

    # Vector with pRF values at which to give status feedback:
    vecStatVol = np.linspace(0,
                             varNumVol,
                             num=(varStsStpSze+1),
                             endpoint=True)
    vecStatVol = np.ceil(vecStatVol)
    vecStatVol = vecStatVol.astype(int)

    # Vector with corresponding percentage values at which to give status
    # feedback:
    vecStatPrc = np.linspace(0,
                             100,
                             num=(varStsStpSze+1),
                             endpoint=True)
    vecStatPrc = np.ceil(vecStatPrc)
    vecStatPrc = vecStatPrc.astype(int)

    # Counter for status indicator:
    varCntSts01 = 0
    varCntSts02 = 0

    # *************************************************************************
    # *** Smoothing

    print('--Applying smoothing')

    for idxVol in range(varNumVol):

        # Status indicator:
        if varCntSts02 == vecStatVol[varCntSts01]:

            # Prepare status message:
            strStsMsg = ('------------Progress: ' +
                         str(vecStatPrc[varCntSts01]) +
                         ' % --- ' +
                         str(vecStatVol[varCntSts01]) +
                         ' volumes out of ' +
                         str(varNumVol))

            print(strStsMsg)

            # Only increment counter if the last value has not been
            # reached yet:
            if varCntSts01 < varStsStpSze:
                varCntSts01 = varCntSts01 + int(1)

        # Apply smoothing to current volume:
        aryNii[:, :, :, idxVol] = aniso_diff_3D(aryNii[:, :, :, idxVol],
                                                niter=3,
                                                kappa=90,
                                                gamma=0.2,
                                                step=(1.0, 1.0, 1.0),
                                                option=1,
                                                ploton=False)

        # Increment status indicator counter:
        varCntSts02 = varCntSts02 + 1

    # *************************************************************************
    # *** Post-processing

    print('--Post-processing')

    # Set masked-out values back to zero:
    aryNii[aryNiiMsk, :] = 0.0

    # *************************************************************************
    # *** Save result

    print('--Saving result to disk')

    print(('---Saving: ' + strPthOut))

    # Create nii object for results:
    objNiiOut = nb.Nifti1Image(aryNii,
                               aryAff,
                               header=objHdr
                               )

    # Save nii:
    nb.save(objNiiOut, strPthOut)

print('-Done.')
