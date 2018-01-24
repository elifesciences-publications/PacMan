"""
The purpose of this script is to change the temporal order of volumes in a 4D
nii file. This script may be used when opposite-phase-encode direction data is
to be motion corrected with SPM, and the reference volume is supposed to be the
last volume in the time series (because the images are supposed to be in good
registry with the following run). Since the last volume cannot be selected as
the reference volume in SPM, one has to change the order to volumes, as a
workaround.
Note: The original file is deleted.
(C) Ingo Marquardt, 02.09.2016
"""


print('-Swap temporal order of volumes in 4D nii file.')


# *****************************************************************************
# *** Define parameters

# Path to images to be swapped:
lstPathIn = ['/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_01.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_02.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_03.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_04.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_05.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_06.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_07.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_08.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_09.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op/func_10.nii.gz']

# Output file paths:
lstPathOt = ['/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_01.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_02.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_03.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_04.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_05.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_06.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_07.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_08.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_09.nii.gz',
             '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/func_op_inv/func_10.nii.gz']
# *****************************************************************************


# *****************************************************************************
# *** Import modules

import os
import numpy as np
import nibabel as nib
# *****************************************************************************


# *****************************************************************************
# ***  Define functions

def fncLoadNii(strPathIn):

    """
    Function for loading nii files.
    """

    print(('------Loading: ' + strPathIn))
    # Load nii file (this doesn't load the data into memory yet):
    niiTmp = nib.load(strPathIn)
    # Load data into array:
    aryTmp = niiTmp.get_data()
    # Get headers:
    hdrTmp = niiTmp.header
    # Get 'affine':
    aryAff = niiTmp.affine
    # Output nii data as numpy array and header:
    return aryTmp, hdrTmp, aryAff
# *****************************************************************************

# aaa = np.zeros((2, 2, 3))
# aaa[:, :, 0] = np.ones((2, 2))
# aaa[:, :, 1] = np.ones((2, 2)) * 2.0
# aaa[:, :, 2] = np.ones((2, 2)) * 3.0
# bbb = aaa[:, :, ::-1]

# *****************************************************************************
# *** Perform correction

print('---Performing correction')

# Loop through input files:

for idxIn in range(0, len(lstPathIn)):

    # print('------File: ' + lstPathIn[idxIn])

    # Load the nii file:
    aryData, hdrNii, aryAff = fncLoadNii(lstPathIn[idxIn])

    # Reverse the order of the array elements along the fourth dimenstion
    # (i.e. time):
    aryData = aryData[:, :, :, ::-1]

    # Create new nii image:
    niiOut = nib.Nifti1Image(aryData,
                             aryAff,
                             header=hdrNii)

    # Save correctedimage:
    nib.save(niiOut,
             lstPathOt[idxIn])

    # Delete original file:
    os.remove(lstPathIn[idxIn])

print('---Done.')
# *****************************************************************************
