# -*- coding: utf-8 -*-   #noqa
"""
Experimental stimuli for Pac-Man project, to be run in Psychopy.
"""

# Part of Pac-Man library
# Copyright (C) 2017 Marian Schneider & Ingo Marquardt
#
# This program is free software: you can redisvarTribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is disvarTributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import datetime
import numpy as np
from psychopy import visual, core, monitors, logging, event, gui, data

# -----------------------------------------------------------------------------
# *** Define general parameters

# Length of target events [s]:
varDurTar = 0.8

# fMRI volume TR [s]:
varTr = 2.079

# Oscillation frequency of Pac-Man, cycles per TR:
varFrq = 2

# Distance between observer and monitor [cm]:
varMonDist = 99.0  # [99.0] for 7T scanner
# Width of monitor [cm]:
varMonWdth = 30.0  # [30.0] for 7T scanner
# Width of monitor [pixels]:
varPixX = 1920.0  # [1920.0] for 7T scanner
# Height of monitor [pixels]:
varPixY = 1200.0  # [1200.0] for 7T scanner

# Size of Pac-Man [degree of visual angle]:
varPacSze = 7.0

# Background colour:
lstBckgrd = [-0.7, -0.7, -0.7]

# Pac-Man colour:
lstPacClr = [0.0, 0.0, 0.0]

# Time (in seconds) that participants have to respond to a target event in
# order for the event to be logged as a hit:
varRspLogTme = 2.0
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** GUI

# Name of the experiment:
strExpNme = 'PacManStim'

# Dictionary with experiment metadata:
dicExpInfo = {'Run': [str(x).zfill(2) for x in range(1, 11)],
              'Subject_ID': 'Pilot',
              'Test mode': [False, True]}

# Pop-up GUI to let the user select parameters:
objGui = gui.DlgFromDict(dictionary=dicExpInfo,
                         title=strExpNme)

# Close if user presses 'cancel':
if objGui.OK is False:
    core.quit()

# Testing (if True, timer is displayed):
lgcTest = dicExpInfo['Test mode']
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Logging

# Set clock:
objClck = core.Clock()

# Switch that is used to control the logging of target events:
varSwtTrgtLog = 1

# Control the logging of participant responses:
varSwtRspLog = 0

# The key that the participant has to press after a target event:
strTrgtKey = '1'

# Counter for correct/incorrect responses:
varCntHit = 0  # Counter for hits
varCntMis = 0  # Counter for misses

# Set clock for logging:
logging.setDefaultClock(objClck)

# Add time stamp and experiment name to metadata:
dicExpInfo['Date'] = data.getDateStr().encode('utf-8')
dicExpInfo['Experiment_Name'] = strExpNme

# Path of this file:
strPthMain = os.path.dirname(os.path.abspath(__file__))

# Get parent path:
strPthPrnt = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Path of logging folder (parent to subject folder):
strPthLog = (strPthPrnt
             + os.path.sep
             + 'log')

# If it does not exist, create subject folder for logging information
# pertaining to this session:
if not os.path.isdir(strPthLog):
    os.makedirs(strPthLog)

# Path of subject folder:
strPthSub = (strPthLog
             + os.path.sep
             + str(dicExpInfo['Subject_ID'])
             )

# If it does not exist, create subject folder for logging information
# pertaining to this session:
if not os.path.isdir(strPthSub):
    os.makedirs(strPthSub)

# Name of log file:
strPthLog = (strPthSub
             + os.path.sep
             + '{}_{}_Run_{}_{}'.format(dicExpInfo['Subject_ID'],
                                        dicExpInfo['Experiment_Name'],
                                        dicExpInfo['Run'],
                                        dicExpInfo['Date'])
             )

# Create a log file and set logging verbosity:
fleLog = logging.LogFile(strPthLog + '.log', level=logging.WARNING)

# Log parent path:
fleLog.write('Parent path: ' + strPthPrnt + '\n')

# Set console logging verbosity:
logging.console.setLevel(logging.WARNING)

# Array for logging of key presses:
aryKeys = np.array([], dtype=np.float32)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Setup

# Create monitor object:
objMon = monitors.Monitor('Screen_7T_NOVA_32_Channel_Coil',
                          width=varMonWdth,
                          distance=varMonDist)

# Set size of monitor:
objMon.setSizePix([varPixX, varPixY])

# Log monitor info:
fleLog.write(('Monitor_Distance: varMonDist = '
              + str(varMonDist)
              + ' cm'
              + '\n'))
fleLog.write(('Monitor width: varMonWdth = '
              + str(varMonWdth)
              + ' cm'
              + '\n'))
fleLog.write(('Monitor width: varPixX = '
              + str(varPixX)
              + ' pixels'
              + '\n'))
fleLog.write(('Monitor height: varPixY = '
              + str(varPixY)
              + ' pixels'
              + '\n'))

# Set screen:
objWin = visual.Window(
    size=(varPixX, varPixY),
    screen=0,
    winType='pyglet',  # winType : None, ‘pyglet’, ‘pygame’
    allowGUI=False,
    allowStencil=True,
    fullscr=True,
    monitor=objMon,
    color=lstBckgrd,
    colorSpace='rgb',
    units='deg',
    blendMode='avg'
    )
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Experimental stimuli

# Initial orientation of Pac-Man figure:
varPacOri = 125

# Pacman figure:
objPacStim = visual.RadialStim(
    win=objWin,
    mask='none',
    units='deg',
    pos=(0, 0),
    size=varPacSze,
    radialCycles=0,
    angularCycles=0,
    radialPhase=0,
    angularPhase=0,
    ori=varPacOri,
    texRes=64,
    angularRes=100,
    visibleWedge=(0, 290),
    colorSpace='rgb',
    color=lstPacClr,
    interpolate=True,
    autoLog=False,
    )

# Inner part of Pac-Man [?]:
objPacIn = visual.GratingStim(
    win=objWin,
    tex='none',
    units='deg',
    size=(0.5),
    mask='none',
    color=lstPacClr,
    colorSpace='rgb',
    ori=0,
    autoLog=False,
    )

# Fixation dot:
objFix = visual.Circle(
    objWin,
    units='deg',
    pos=(0, 0),
    radius=0.04,
    edges=24,
    fillColor=[1.0, 0.0, 0.0],
    fillColorSpace='rgb',
    lineColor=[1.0, 0.0, 0.0],
    lineColorSpace='rgb',
    lineWidth=0.0,
    interpolate=True,
    autoLog=False,
    )

# Fication dot surround:
objFixSrd = visual.Circle(
    objWin,
    units='deg',
    pos=(0, 0),
    radius=0.07,
    edges=24,
    fillColor=[0.5, 0.5, 0.0],
    fillColorSpace='rgb',
    lineColor=[0.5, 0.5, 0.0],
    lineColorSpace='rgb',
    lineWidth=0.0,
    interpolate=True,
    autoLog=False,
    )

# Target:
objTarget = visual.Circle(
    objWin,
    units='deg',
    pos=(0, 0),
    edges=24,
    radius=0.07,
    fillColor=[0.8, 0.1, 0.1],
    fillColorSpace='rgb',
    lineColor=[0.8, 0.1, 0.1],
    lineColorSpace='rgb',
    lineWidth=0.0,
    interpolate=True,
    autoLog=False
    )
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Auxiliary stimuli

# Message:
objTxtWlcm = visual.TextStim(objWin,
                             text='Please wait a moment.',
                             font="Courier New",
                             pos=(0, 0),
                             color=(1.0, 1.0, 1.0),
                             colorSpace='rgb',
                             opacity=1.0,
                             contrast=1.0,
                             ori=0.0,
                             height=0.8,
                             antialias=True,
                             alignHoriz='center',
                             alignVert='center',
                             flipHoriz=False,
                             flipVert=False,
                             autoLog=False
                             )

# Timer (only displayed in testing mode):
if lgcTest:
    # The text for the timer:
    objTxtTmr = visual.TextStim(objWin,
                                text='Time',
                                font="Courier New",
                                pos=(0, -5.0),
                                color=[1.0, 1.0, 1.0],
                                colorSpace='rgb',
                                opacity=1.0,
                                contrast=1.0,
                                ori=0.0,
                                height=0.4,
                                antialias=True,
                                alignHoriz='center',
                                alignVert='center',
                                flipHoriz=False,
                                flipVert=False,
                                autoLog=False
                                )

    # Background rectangle to increase visibility of the text:
    objRect = visual.Rect(objWin,
                          pos=(0, -5.0),
                          width=2.5,
                          height=0.6,
                          lineColorSpace='rgb',
                          fillColorSpace='rgb',
                          units='deg',
                          lineWidth=1.0,
                          lineColor=[-0.7, -0.7, -0.7],
                          fillColor=[-0.7, -0.7, -0.7],
                          autoLog=False
                          )
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Trials

# Load event matrix from text file:
strPthDsgn = (strPthPrnt
              + os.path.sep
              + 'design_matrices'
              + os.path.sep
              + 'PacMan_run_'
              + str(dicExpInfo['Run'])
              + '_eventmatrix.txt')

# Read design matrix:
aryDesign = np.loadtxt(strPthDsgn, delimiter=' ', unpack=False)

# Total number of events:
varNumEvnts = aryDesign.shape[0]

# Because indexing starts with 0, we have to adjust the number of events:
varNumEvnts = (varNumEvnts - 1)
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Function definitions

def func_exit():
    """
    Check whether exit-keys have been pressed.

    The exit keys are 'e' and 'x'; they have to be pressed at the same time.
    This is supposed to make it less likely that they experiment is aborted
    unpurposely.
    """
    # Check keyboard, save output to temporary string:
    strExit = event.getKeys(keyList=['e', 'x'], timeStamped=False)

    # Whether the list has the correct length (if nothing has happened strExit
    # will have length zero):
    if len(strExit) != 0:

        if ('e' in strExit) and ('x' in strExit):

            # Log end of experiment:
            logging.data('------Experiment aborted by user.------')

            # Make the mouse cursor visible again:
            event.Mouse(visible=True)

            # Close everyting:
            objWin.close()
            core.quit()
            monitors.quit()
            logging.quit()
            event.quit()

            return 1

        else:
            return 0

    else:
        return 0
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Presentation

# Draw wait message:
objTxtWlcm.draw()
objWin.flip()

# Hide the mouse cursor:
event.Mouse(visible=False)

# Wait for scanner trigger pulse & set clock after receiving trigger pulse
# (scanner trigger pulse is received as button press ('5')):
strTrgr = ['0']
while strTrgr[0][0] != '5':
    # Check for keypress:
    strTmp = event.getKeys(keyList=['5'], timeStamped=False)
    # Whether the list has the correct length (if nothing has happened, strTmp
    # will have length zero):
    if len(strTmp) == 1:
        strTrgr = strTmp[0][0]

# Trigger pulse received, reset clock:
objClck.reset(newT=0.0)

# Main timer which represents the starting point of the experiment:
objTme01 = objClck.getTime()

# Timer that is used to control the logging of stimulus events:
objTme03 = objClck.getTime()

# Start of the experiment:
for idx01 in range(0, varNumEvnts):  #noqa

    # Check whether exit keys have been pressed:
    if func_exit() == 1:
        break

    # Index for execution of target events:
    varIdxTrgt = 1

    # The first colume of the event matrix signifies the event type (REST is
    # coded as '1', STIMULUS as '3', and TARGET events are coded as '2'):
    varTmpEvntType = aryDesign[idx01][0]

    # The second column of the event matrix signifies the time (in seconds)
    # when the event starts:
    varTmpEvntStrt = aryDesign[idx01][1]

    # The third column of the event matrix signifies the duration (in seconds)
    # of the event:
    varTmpEvntDur = aryDesign[idx01][2]

    # Get the time:
    objTme02 = objClck.getTime()

    # Is the upcoming event a REST BLOCK?
    if varTmpEvntType == 1:

        # Log beginning of rest block:
        strTmp = ('REST_start_of_block_'
                  + str(idx01 + 1)
                  + '_scheduled_for:_'
                  + str(varTmpEvntStrt))
        logging.data(strTmp)

        # Switch for target (show target or not?):
        varSwtTrgt = 0

        # Continue with the rest block?
        while objTme02 < (objTme01 + varTmpEvntStrt + varTmpEvntDur):

            # Draw fixation dot:
            objFix.draw(win=objWin)
            objFixSrd.draw(win=objWin)

            # Draw target?
            if varSwtTrgt == 1:

                    # Draw target:
                    objTarget.draw()

                    # Log target?
                    if varSwtTrgtLog == 1:

                        # Log target event:
                        strTmp = ('TARGET_scheduled_for:_'
                                  + str(var_temp_target_start))
                        logging.data(strTmp)

                        # Switch off (so that the target event is only logged
                        # once):
                        varSwtTrgtLog = 0

                        # Once after target onset we set varSwtRspLog to
                        # one so that the participant's respond can be logged:
                        varSwtRspLog = 1

                        # Likewise, just after target onset we set the timer
                        # for response logging to the current time so that the
                        # response will only be counted as a hit in a specified
                        # time interval after target onset:
                        objTme03 = objClck.getTime()

            # Timer (only displayed in testing mode):
            if lgcTest:

                # Set time since experiment onset as message text:
                objTxtTmr.text = str(np.around(objTme02, 1)) + ' s'

                # Draw background rectangle:
                objRect.draw()
                # Draw text:
                objTxtTmr.draw()

            # Flip drawn objects to screen:
            objWin.flip()

            # Check whether exit keys have been pressed:
            if func_exit() == 1:
                break

            # Check for and log participant's response:
            objTme02 = objClck.getTime()
            strRsps = event.getKeys(keyList=[strTrgtKey], timeStamped=False)

            if (varSwtRspLog == 1) and \
            (objTme02 <= (objTme03 + varRspLogTme)):
                # Check whether the list has the correct length:
                if len(strRsps) == 1:
                    if strRsps[0] == strTrgtKey:
                        logging.data('Hit') # Log hit
                        varCntHit += 1 # Count hit
                        # After logging the hit, we have to switch off the
                        # response logging, so that the same hit is nor logged
                        # over and over again:
                        varSwtRspLog = 0
                    else:
                        print('Fatal error - key press.')
                        logging.data('Fatal error - key press.')
            elif (varSwtRspLog == 1) and \
            (objTme02 > (objTme03 + varRspLogTme)):
                logging.data('Miss') # Log miss
                varCntMis += 1 # Count miss
                # If the subject does not respond to the target within time, we
                # log this as a miss and set varSwtRspLog to zero (so
                # that the response won't be logged as a hit anymore
                # afterwards):
                varSwtRspLog = 0
            # Check whether it's time to show a target on the next frame:
            # Is the upcoming event a target?
            if aryDesign[idx01+varIdxTrgt][0] == 2:
                var_temp_target_start = aryDesign[idx01+varIdxTrgt][1]
                # Has the start time of the target event been reached?
                if objTme02 >= (objTme01 + var_temp_target_start):
                    varSwtTrgt = 1
                    # Has the end time of the target event been reached?
                    if objTme02 >= \
                    (objTme01 + var_temp_target_start + varDurTar):
                        # Switch the target off:
                        varSwtTrgt = 0
                        # Switch on the logging of the target event (so that
                        # the next target event will be logged):
                        varSwtTrgtLog = 1
                        # Only increase the index if the end of the design
                        # matrix has not been reached yet:
                        if (idx01 + varIdxTrgt) < varNumEvnts:
                            # Increase the index to check whether the next
                            # event in the design matrix is also a target
                            # event:
                            varIdxTrgt = varIdxTrgt + 1
            objTme02 = objClck.getTime()
        # Log end of rest block:
        strTmp = ('REST_end_of_event_' + unicode(idx01 + 1))
        logging.data(strTmp)
    # Is the upcoming event a STIMULUS BLOCK?
    elif varTmpEvntType == 3:
        # Log beginning of stimulus block:
        strTmp = ('STIMULUS_start_of_block_' + \
                    unicode(idx01 + 1) + \
                    '_scheduled_for:_' + \
                    unicode(varTmpEvntStrt))
        logging.data(strTmp)
        # Switch stimulus flicker:
        var_switch_flc = 1
        # Switch target:
        varSwtTrgt = 0
        # Timer that is used for the stimulus flicker:
        tme_5 = objClck.getTime()
        # Continue with the stimulus block?
        while objTme02 < (objTme01 + varTmpEvntStrt + varTmpEvntDur):
            # Draw main stimulus:
            if var_switch_comp == 0:
                if var_switch_flc == 1:
                    vsl_stim_by_01.draw()
                elif var_switch_flc == 2:
                    vsl_stim_by_02.draw()
                elif var_switch_flc == 3:
                    vsl_stim_by_03.draw()
                elif var_switch_flc == 4:
                    vsl_stim_by_04.draw()
            elif var_switch_comp == 1:
                if var_switch_flc == 1:
                    vsl_stim_rg_01.draw()
                elif var_switch_flc == 2:
                    vsl_stim_rg_02.draw()
                elif var_switch_flc == 3:
                    vsl_stim_rg_03.draw()
                elif var_switch_flc == 4:
                    vsl_stim_rg_04.draw()
            # Check whether it's time to switch polarity of the stimulus:
            if objTme02 >= (tme_5 + var_stim_dur):
                # Switch the switch:
                if var_switch_flc < 4:
                    var_switch_flc = var_switch_flc + 1
                    # Timer that is used for the stimulus flicker:
                    tme_5 = objClck.getTime()
                elif var_switch_flc == 4:
                    var_switch_flc = 1
                    # Timer that is used for the stimulus flicker:
                    tme_5 = objClck.getTime()
                else:
                    print('Fatal error - stimulus flicker.')
                    logging.data('Fatal error - stimulus flicker.')
            # Fixation cross and (if necessary) the target:
            vsl_fixation.draw(win=objWin)
            if varSwtTrgt == 1:
                    objTarget.draw()
                    if varSwtTrgtLog == 1:
                        # Log target event:
                        strTmp = ('TARGET_scheduled_for:_' + \
                                    unicode(var_temp_target_start)) # analysis:ignore
                        logging.data(strTmp)
                        # Switch off (so that the target event is only logged
                        # once):
                        varSwtTrgtLog = 0
                        # Once after target onset we set varSwtRspLog to
                        # one so that the participant's respond can be logged:
                        varSwtRspLog = 1
                        # Likewise, just after target onset we set the timer
                        # for response logging to the current time so that the
                        # response will only be counted as a hit in a specified
                        # time interval after target onset:
                        objTme03 = objClck.getTime()
            # Timer (only displayed in testing mode):
            if lgcTest:
                # Set time since experiment onset as message text:
                objTxtTmr.text = str(np.around(objTme02, 1)) + ' s'
                # Draw background rectangle:
                objRect.draw()
                # Draw text:
                objTxtTmr.draw()
            objWin.flip()
            # Check whether exit keys have been pressed:
            if func_exit() == 1:
                break
            # Check for and log participant's response:
            objTme02 = objClck.getTime()
            strRsps = event.getKeys(keyList=[strTrgtKey], timeStamped=False)
            if (varSwtRspLog == 1) and \
            (objTme02 <= (objTme03 + varRspLogTme)):
                # Check whether the list has the correct length:
                if len(strRsps) == 1:
                    if strRsps[0] == strTrgtKey:
                        logging.data('Hit') # Log hit
                        varCntHit += 1 # Count hit
                        # After logging the hit, we have to switch off the
                        # response logging, so that the same hit is nor logged
                        # over and over again:
                        varSwtRspLog = 0
                    else:
                        print('Fatal error - key press.')
                        logging.data('Fatal error - key press.')
            elif (varSwtRspLog == 1) and \
            (objTme02 > (objTme03 + varRspLogTme)):
                logging.data('Miss') # Log miss
                varCntMis += 1 # Count miss
                # If the subject does not respond to the target within time, we
                # log this as a miss and set varSwtRspLog to zero (so
                # that the response won't be logged as a hit anymore
                # afterwards):
                varSwtRspLog = 0
            # Check whether it's time to show a target on the next frame:
            # Is the upcoming event a target?
            if aryDesign[idx01+varIdxTrgt][0] == 2:
                var_temp_target_start = aryDesign[idx01+varIdxTrgt][1]
                # Has the start time of the target event been reached?
                if objTme02 >= (objTme01 + var_temp_target_start):
                    varSwtTrgt = 1
                    # Has the end time of the target event been reached?
                    if objTme02 >= \
                    (objTme01 + var_temp_target_start + varDurTar):
                        # Switch the target off:
                        varSwtTrgt = 0
                        # Switch on the logging of the target event (so that
                        # the next target event will be logged):
                        varSwtTrgtLog = 1
                        # Only increase the index if the end of the design
                        # matrix has not been reached yet:
                        if (idx01 + varIdxTrgt) < varNumEvnts:
                            # Increase the index to check whether the next
                            # event in the design matrix is also a target
                            # event:
                            varIdxTrgt = varIdxTrgt + 1
            objTme02 = objClck.getTime()
        # Log end of stimulus block:
        strTmp = ('STIMULUS_end_of_event_' + unicode(idx01 + 1))
        logging.data(strTmp)
        # Switch the stimulus component switch for the next stimulus block (so
        # that a red-green block is followed by a blue-yellow block, and vice
        # versa):
        if var_switch_comp == 0:
            var_switch_comp = 1
        elif var_switch_comp == 1:
            var_switch_comp = 0
# Present participant with feedback on her target detection performance:
str_feedback = ('You have detected ' + \
                unicode(varCntHit) + \
                ' targets out of ' + \
                unicode(varCntHit + varCntMis))
objTxtTmr = visual.TextStim(objWin,
                            text=str_feedback,
                            font="Courier New",
                            pos=(0, 0),
                            color=(1.0, 1.0, 1.0),
                            colorSpace='rgb',
                            opacity=1.0,
                            contrast=1.0,
                            ori=0.0,
                            height=0.5,
                            antialias=True,
                            alignHoriz='center',
                            alignVert='center',
                            flipHoriz=False,
                            flipVert=False,
                            autoLog = False)
tme_4 = objClck.getTime()
while objTme02 < (tme_4 + 3.0):
    objTxtTmr.draw()
    objWin.flip()
    objTme02 = objClck.getTime()
# Log total number of hits and misses:
logging.data('------End of the experiment.------')
logging.data(('Number_of_hits_=_' + unicode(varCntHit)))
logging.data(('Number_of_misses_=_' + unicode(varCntMis)))
# -----------------------------------------------------------------------------
# *** End of the experiment
# Make the mouse cursor visible again:
event.Mouse(visible=True)
# Close everyting:
objWin.close()
core.quit()
monitors.quit()
logging.quit()
event.quit()
# -----------------------------------------------------------------------------
