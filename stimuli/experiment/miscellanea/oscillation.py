# -*- coding: utf-8 -*-
"""
Pac-Man oscillation parameters.

Use this script in an interactive IDE (e.g. spyder) to adjust the parameters of
the Pac-Man stimulus.
"""

import numpy as np


# -----------------------------------------------------------------------------
# *** Oscillation frequency

# Vector representing time in seconds:
vecTme = np.linspace(0.0, 10.0, num=1000)

# Cycles per second:
varFrq = 0.6

# Maximum displacement of Pac-Man (relative to horizontal meridian) in degrees
# (up and down; i.e. total displacement is 2 * varOscMax):
varOscMax = 35.0

# Pac-Man orientation as a function of time:
vecOri = np.multiply(
                     np.sin(
                             np.deg2rad(
                                        vecTme
                                        * 360.0
                                        * float(varFrq)
                                        )
                            ),
                     float(varOscMax)
                     )
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Rotational speed

# Size of Pac-Man [degree of visual angle]:
varPacSze = 7.0

# Calculate speed at following eccentricity:
varEcc = 3.5

# Size of Pac-Man's 'mouth' [deg]; i.e half of the. angular distance covered
# per cycle:
varMouth = 70.0

# Circumference of Pac-Man (if it was a full circle) in degree of visual angle:
varCrc = 0.5 * varEcc * np.pi

# Angular distance travelled in one cycle:
varAngDst = (varMouth / 360.0) * varCrc * 2.0

# Angular speed in degree of visual angle per second:
varSpd = varAngDst * varFrq
# -----------------------------------------------------------------------------
