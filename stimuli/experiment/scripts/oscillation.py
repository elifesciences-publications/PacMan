# -*- coding: utf-8 -*-
"""
Pac-Man oscillation parameters.

Use this script in an interactive IDE (e.g. spyder) to adjust the parameters of
the Pac-Man stimulus.
"""

import numpy as np

# Vector representing time in seconds:
vecTme = np.linspace(0.0, 10.0, num=1000)

# Cycles per second:
varFrq = 0.5

# Maximum displacement of Pac-Man (relative to horizontal meridian) in degrees:
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
