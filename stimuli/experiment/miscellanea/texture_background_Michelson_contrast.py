#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Calculate peak-to-peak Michelson contrast of texture background pattern."""

import numpy as np
import imageio

# Path of background texture used in Pac-Man experiment:
path_png = '/home/john/PhD/GitLab/PacMan/stimuli/experiment/miscellanea/texture_background.png'

# Read texture from png to numpy array:
texture = imageio.imread(path_png)

# Get greyscale intensity (one could take any of the RGB channels, since it's
# a greyscale image and the RGB channels are equal):
texture = np.mean(texture[:, :, 0:3], axis=2)

# Minimum and maximum pixel intensity (uint, 0 to 255):
pix_min = np.min(texture)
pix_max = np.max(texture)

# Minimum and maximum pixel intensity (float, -1 ro 1):
pix_min = ((float(pix_min) / 255.0) * 2.0) - 1.0
pix_max = ((float(pix_max) / 255.0) * 2.0) - 1.0


def pix_to_lum(pixel_intensity):
    """
    Pixel intensity to luminance.

    Parameters
    ----------
    pixel_intensity : float
        Pixel intensity (in Psychopy convention, i.e. range -1.0 to 1.0).

    Returns
    -------
    luminance : float
        Luminance in cd/m2.

    Notes
    -----
    The relation between pixel intensity and luminance on our projection system
    was given by
    y = -78.8 * x^3 + 78.7 * x^2 + 317.2 * x + 163.3
    where x represents the pixel intensity (in Psychopy convention, i.e. range
    -1.0 to 1.0), and y corresponds to luminance (in cd/m2 ).

    """
    pixel_intensity = float(pixel_intensity)

    luminance = (-78.8 * pixel_intensity**3
                 + 78.7 * pixel_intensity**2
                 + 317.2 * pixel_intensity
                 + 163.3)

    return luminance


# Minimum and maximum luminance:
lum_min = pix_to_lum(pix_min)
lum_max = pix_to_lum(pix_max)

# Michelson contrast:
contrast = (lum_max - lum_min) / (lum_max + lum_min)
