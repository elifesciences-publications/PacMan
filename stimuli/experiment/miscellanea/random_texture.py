"""
Random noise pattern through uniform filter.
"""

import numpy as np
from  scipy.ndimage import uniform_filter
from PIL import Image

# -----------------------------------------------------------------------------
# *** Define parameters

# Size of texture [pixels]:
tplSze = (1920, 1200)

# Size of uniform filter [pixels]:
varUniFlt = 6

# Mean pixel intensity [RGB intensity, 0 to 255]:
varPix = ((-0.71 + 1.0) * 0.5) * 255.0  # 37

# Standard deviation of pixel intensity before smoothing [RGB intensity, 0 to
# 255]:
varSd = ((-0.5294117647058824 + 1.0) * 0.5) * 255.0  # 60.0

# Output path (mean intensity, standard deviation, and filter size left open):
strPthOut = '/home/john/Desktop/random_texture_mne_{}_sd_{}_fltr_{}.png'

# -----------------------------------------------------------------------------
# *** Create texture

# Create random noise array:
aryRndn = np.random.randn(tplSze[1], tplSze[0])

# Scale variance:
aryRndn = np.multiply(aryRndn, varSd)

# Scale mean pixel intensity:
aryRndn = np.add(aryRndn, varPix)

# Apply filter:
aryRndnS = uniform_filter(aryRndn, size=varUniFlt)

# Avoid out of range values (set to back or white accordingly):
aryLgc = np.less(aryRndnS, 0.0)
aryRndnS[aryLgc] = 0.0
aryLgc = np.greater(aryRndnS, 255.0)
aryRndnS[aryLgc] = 255.0

# Cast to interget:
aryRndnS = np.around(aryRndnS).astype(np.uint8)

# -----------------------------------------------------------------------------
# *** Save texture

# Create image:
objImg = Image.fromarray(aryRndnS, mode='L')

# Save image to disk:
objImg.save(strPthOut.format(str(np.around(varPix)),
                             str(np.around(varSd)),
                             str(varUniFlt)))
# -----------------------------------------------------------------------------
