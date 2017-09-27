# -*- coding: utf-8 -*-


"""
Identify noise components in MELODIC output.

The purpose of this script is to help identify noise components in MELODIC ICA
output. To this end, independent components are sorted based on the ratio of
intensity within and outside of grey matter.
"""


# Part of PacMan library
# Copyright (C) 2017  Ingo Marquardt
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


# *****************************************************************************
# *** Import modules
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from utilities import fncLoadNii
# *****************************************************************************


# *****************************************************************************
# *** Define parameters

# Path of MELODIC ICA reports (run ID left open):
strPathIca = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/feat_level_1/func_{}.feat/filtered_func_data.ica/melodic_IC.nii.gz'

# List of runs:
lstRun = ['07', '08', '09', '10']

# Path of mask (e.g. brain mask or grey matter mask):
strPathMsk = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/retinotopy/mask/20161221_mp2rage_seg_v26_lh_gm_down_mod.nii.gz'

# Output directory:
strPathOut = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/retinotopy/ICA_noise_analysis/'
# *****************************************************************************


# *****************************************************************************
# *** Preparations

print('-ICA Ratio analysis')

# Load mask:
aryMsk, _, _ = fncLoadNii(strPathMsk)

# Convert mask into boolean array:
aryMsk = np.greater(aryMsk,
                    np.min(aryMsk))
# *****************************************************************************


# *****************************************************************************
# *** Loop through runs

for idxRun in lstRun:

    # *************************************************************************
    # *** Calculate ICA ratio

    print(('---Run: ' + idxRun))

    # Load ICA results:
    aryIca, _, _ = fncLoadNii(strPathIca.format(idxRun))

    # Voxels within mask:
    aryIn = aryIca[aryMsk]    

    # Voxels outside mask:
    aryOut = aryIca[np.logical_not(aryMsk)]

    # Median absolute ICA intensities within mask:
    vecIcaIn = np.median(np.absolute(aryIn), axis=0)

    # Median absolute ICA intensities outside mask:
    vecIcaOut = np.median(np.absolute(aryOut), axis=0)

    # Ratio of absolute ICA intensities outside/within mask:
    vecRatio = np.divide(vecIcaOut, vecIcaIn)

    # Indicies to sort ICA ratios from largest to smallest:
    vecSort = np.argsort(vecRatio)[::-1]

    # Array with ICA component index in first column, and ICA ratio in second
    # column. Component indicies start at zero, because MELODIC components
    # are indexed this way in FSL.
    aryRatio = np.array([np.arange(1.0, (vecRatio.shape[0] + 1),
                                   dtype=np.float32),
                         vecRatio]).T

    # Sort ratios (larger ratio -> ICA component is stronger outside of mask):
    aryRatio = aryRatio[vecSort, :]
    # *************************************************************************

    # *************************************************************************
    # *** Indicies of highest ratios

    # Percentile threshold:
    varThr = 75.0

    # Pecentile:
    varPrcnt = np.percentile(aryRatio[:, 1], varThr)

    # Array indicies of ratios above percentile:
    vecLgcPrcnt = np.greater(aryRatio[:, 1], varPrcnt)

    # Indicies of MELODIC ICA components above percentile:
    vecUpIdx = aryRatio[vecLgcPrcnt, 0].astype(np.int16)

    # Temporary path for output file:
    strPathTmp = (strPathOut + 'ICA_remove_' + idxRun + '.txt')

    # Header with information:
    strHdrTmp = ('ICA components to remove, based on upper '
                 + str(varThr)
                 + 'th percentile for run '
                 + idxRun
                 + ': ')

    # Save to text file:
    np.savetxt(strPathTmp,
               vecUpIdx,
               fmt='%i',
               newline=',',  # delimiter=',',
               header=strHdrTmp)
    # *************************************************************************

    # *************************************************************************
    # *** Export results (text)

    # Vector for x-data:
    vecX = np.arange(0, vecRatio.shape[0], dtype=np.int16)

    # Put array with ICA ratios into pandas dataframe:
    pndRatio = pd.DataFrame(data=aryRatio,
                            index=vecX,
                            columns=['Component', 'Ratio'])

    # Change datatype of components column:
    pndRatio['Component'] = pndRatio['Component'].astype(np.int16)

    # Round ratio values:
    pndRatio['Ratio'] = np.around(pndRatio['Ratio'], decimals=3)

    # Temporary path for output file:
    strPathTmp = (strPathOut + 'ICA_ratio_' + idxRun + '.txt')

    # Save dataframe to text file:
    pndRatio.to_csv(strPathTmp, header=True, index=False, sep='\t')

    # Convert dataframe to unicode object (latex formatting):
    # uniRatio = pndRatio.to_latex()
    # Save to disk:
    # fleRatio = open(strPathTmp, 'w')
    # fleRatio.write(uniRatio)
    # fleRatio.close()
    # *************************************************************************

    # *************************************************************************
    # *** Plot results

    # Figure parameters:
    strTitle = ('ICA Ratio ' + idxRun)
    strPathTmp = (strPathOut + 'ICA_ratio_' + idxRun + '.png')
    varSizeX = 1400.0
    varSizeY = 1000.0
    varDpi = 90.0

    # Create figure:
    fgr01 = plt.figure(figsize=((varSizeX * 0.5) / varDpi,
                                (varSizeY * 0.5) / varDpi),
                       dpi=varDpi)

    # Create axis:
    axs01 = fgr01.add_subplot(111)

    # Vector for x-data:
    vecX = np.arange(0.0, vecRatio.shape[0])

    # Plot depth profile for current input file:
    plt01 = axs01.plot(vecX,  #noqa
                       aryRatio[:, 1],
                       color=[31.0 / 255.0,
                              185.0 / 255.0,
                              249.0 / 255.0],
                       alpha=0.9,
                       label=idxRun,
                       linewidth=9.0,
                       antialiased=True)

    # Set x-axis range:
    # axs01.set_xlim([])

    # Set y-axis range:
    # axs01.set_ylim([])

    # Which x values to label with ticks:
    # axs01.set_xticks([])

    # Set tick labels for x ticks:
    # axs01.set_xticklabels([''])

    # Which y values to label with ticks:
    # vecYlbl = np.linspace()
    # Round:
    # vecYlbl = np.around(vecYlbl, decimals=2)

    # Set ticks:
    # axs01.set_yticks(vecYlbl)

    # Set tick labels for y ticks:
    # axs01.set_yticklabels(lstYlbl)

    # Set x & y tick font size:
    axs01.tick_params(labelsize=36)
    #                  top='off',
    #                  right='off')

    # Adjust labels:
    # axs01.set_xlabel(strXlabel,
    #                  fontsize=36)
    # axs01.set_ylabel(strYlabel,
    #                  fontsize=36)

    # Adjust title:
    axs01.set_title(strTitle, fontsize=36, fontweight="bold")

    # Appearance of axes:
    for strTmp in ['top','bottom','left','right']:
      axs01.spines[strTmp].set_linewidth(3.0)

    # Reduce framing box:
    #axs01.spines['top'].set_visible(False)
    #axs01.spines['right'].set_visible(False)
    #axs01.spines['bottom'].set_visible(True)
    #axs01.spines['left'].set_visible(True)


    # Legend :
    # axs01.legend(loc=0,
    #              frameon=False,
    #              prop={'size': 26})

    # Make plot & axis labels fit into figure:
    plt.tight_layout(pad=0.5)

    # Save figure:
    fgr01.savefig(strPathTmp,
                  facecolor='w',
                  edgecolor='w',
                  orientation='landscape',
                  transparent=False,
                  frameon=None)

    # Close figure:
    plt.close(fgr01)
    # *************************************************************************
