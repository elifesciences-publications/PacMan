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
import numpy as np
from psychopy import visual, event, core, monitors, data, gui, logging, misc


# %%
"""EXPERIMENTAL PARAMETERS"""

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

# Pac-Man colour:
vecPacClr = [0.0, 0.0, 0.0]

# %%
"""GUI"""

# Name of the experiment:
strExpNme = 'PacManStim'

# Dictionary with experiment metadata:
dicExpInfo = {'Run': [str(x).zfill(2) for x in range(1, 11)],
              'Subject_ID': 'Pilot'}

# Pop-up GUI to let the user select parameters:
objGui = gui.DlgFromDict(dictionary=dicExpInfo,
                         title=strExpNme)

# Close if user presses 'cancel':
if objGui.OK is False:
    core.quit()


# %%
"""LOGGING"""

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

# Set console logging verbosity:
logging.console.setLevel(logging.WARNING)

# Array for logging of key presses:
aryKeys = np.array([], dtype=np.float32)


# %%
"""MONITOR and WINDOW"""

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
    color=[0.0, 0.0, 0.0],
    colorSpace='rgb',
    units='deg',
    blendMode='avg'
    )


# %%
"""CONDITIONS and aryDur"""

# Path to design matrix:
strPthDsgn = (strPthPrnt
              + os.path.sep
              + 'design_matrices'
              + os.path.sep
              + 'PacMan_run_'
              + str(dicExpInfo['Run'])
              + '_eventmatrix.txt')

# Read design matrix:
aryDsgn = np.loadtxt(strPthDsgn, delimiter=' ', unpack=False)

# First row of design matrix contains conditions, coded as integers:
aryCon = aryDsgn[:, 0].astype(np.int16)

# Second row of design matrix contains onset times:
aryOn = aryDsgn[:, 1].astype(np.float32)

# Third row of design matrix contains durations:
aryDur = aryDsgn[:, 2].astype(np.float32)

# Array for target event onset times:
aryTrgt = aryOn[np.equal(aryCon, int(2))]

# Target events (change in fixation dot colour) are coded as '2'. These will be
# dealt with separately. Take them out of the design matrix:
aryOn = aryOn[np.not_equal(aryCon, int(2))]
aryDur = aryDur[np.not_equal(aryCon, int(2))]
aryCon = aryCon[np.not_equal(aryCon, int(2))]

# Write design matrix information to log file:
fleLog.write(('Condition order (1=Rest, 3,4,5...=Stimulus levels): '
              + str(aryCon)
              + '\n'))
fleLog.write(('Condition onset times [s]: '
              + str(aryOn)
              + '\n'))
fleLog.write(('Condition durations [s]: '
              + str(aryDur)
              + '\n'))
fleLog.write(('Target onset times [s]: '
              + str(aryTrgt)
              + '\n'))
fleLog.write(('Target duration [s]: '
              + str(varDurTar)
              + '\n'))


# %%
"""STIMULI"""

# "Both 'Pacman' and the control figure had a luminance value of 503 cd/m2.
# During the dynamic period, the figures oscillated sinusoidally with a half
# period of 480 ms."

# Orientation of Pac-Man figure:
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
    color=vecPacClr,
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
    color=vecPacClr,
    colorSpace='rgb',
    ori=0,
    autoLog=False,
    )

# Fixation dot:
objFix = visual.Circle(
    objWin,
    units='pix',
    radius=2,
    fillColor=[1.0, 0.0, 0.0],
    lineColor=[1.0, 0.0, 0.0],
    autoLog=False,
    )

# Fication dot surround:
objFixSrd = visual.Circle(
    objWin,
    units='pix',
    radius=7,
    fillColor=[0.5, 0.5, 0.0],
    lineColor=[0.0, 0.0, 0.0],
    autoLog=False,
    )

# Welcome message:
objTxtWlcm = visual.TextStim(
    win=objWin,
    colorSpace='rgb',
    color=[1.0, 1.0, 1.0],
    height=0.5,
    text='Experiment will start soon.'
    )


# %%
"""TIME, TIMING and CLOCKS"""

# Total duration of the experiment:
varDurTtl = np.sum(aryDur)
fleLog.write(('Total duration of the experiment: '
              + str(varDurTtl)
              + ' s'
              + '\n'))

# Give system time to settle before it checks screen refresh rate:
core.wait(0.5)

# Get screen refresh rate:
varFps = objWin.getActualFrameRate()

if varFps is not None:
    print(('Frames per second: ' + str(varFps)))
    fleLog.write(('Frames per second: ' + str(varFps) + '\n'))
else:
    # Couldn't get reliable measure, guess:
    varFps = 60.0
    print(('Could not obtain frames per second, defaulting to: '
           + str(varFps)))
    fleLog.write(('Could not obtain frames per second, defaulting to: '
                  + str(varFps)
                  + '\n'))

# Duration of one frame:
varDurFrm = 1.0 / float(varFps)
fleLog.write(('Frame duration: '
             + str(varDurFrm)
             + ' s'
             + '\n'))

# Set clock:
objClck = core.Clock()
logging.setDefaultClock(objClck)


# %%
"""TARGET EVENTS"""

# Target events are presented using a dedicated function.

# Target duration in frames:
varDurTrgtFrms = int(np.around(float(varDurTar) / float(varDurFrm)))

# Set initial value for target counter:
varCntTrgt = varDurTrgtFrms + 1

varTme01 = objClck.getTime()

print(' ')

print('aryTrgt')
print(aryTrgt)

print(' ')

print('(varTme01 >= aryTrgt)')
print((varTme01 >= aryTrgt))

print(' ')

print('len(aryTrgt)')
print(len(aryTrgt))

print(' ')

print('(varTme01 < (aryTrgt + varDurFrm))')
print((varTme01 < (aryTrgt + varDurFrm)))

def fnc_target(varCntTrgt):
    """Present target event."""
    varTme01 = objClck.getTime()

    # Beginning of target event? Set counter to zero.
    if sum(varTme01 >= aryTrgt) + sum(varTme01 < aryTrgt + varDurFrm) == len(aryTrgt) + 1:
        varCntTrgt = 0

    # below number of target frames? display target!
    if varCntTrgt < varDurTrgtFrms:
        # change color fix dot surround to red
        objFixSrd.fillColor = [0.5, 0.0, 0.0]
        objFixSrd.lineColor = [0.5, 0.0, 0.0]
        if ET:
            TargetText = 'TargetFrame'+svarTr(varCntTrgt)
            vpx.VPX_SendCommand('dataFile_InsertSvarTring ' + TargetText)
    # above number of target frames? dont display target!
    else:
        # keep color fix dot surround yellow
        objFixSrd.fillColor = [0.5, 0.5, 0.0]
        objFixSrd.lineColor = [0.5, 0.5, 0.0]

    # update varCntTrgt
    varCntTrgt = varCntTrgt + 1

    return varCntTrgt


#
#
##%%
#"""RENDER_LOOP"""
## Create Counters
#i = 0 # counter for blocks
##miniCounter = -1 # counter for mini blocks
## give system time to settle before stimulus presentation
#core.wait(0.5)
#
##wait for scanner varTrigger
#objTxtWlcm.draw()
#objWin.flip()
#event.waitKeys(keyList=['5'], timeStamped=False)
## set switch
#motionSwitch = False
## reset objClck
#objClck.reset()
#logging.data('StartOfRun'+ unicode(dicExpInfo['Run']))
#
#while objClck.getTime()<varDurTtl:
#
#    if aryCon[i] == 1: # rest
#        motionSwitch = False
#        objPacStim.opacity = 0
#        objPacIn.opacity = 0
#
#    elif aryCon[i] == 3: # pacman stim static
#        motionSwitch = False
#        objPacStim.opacity = 1
#        objPacIn.opacity = 1
#        objPacStim.ori = varPacOri
#        objPacIn.ori = 0
#
#    elif aryCon[i] == 4: # pacman stim move
#        motionSwitch = True
#        objPacStim.opacity = 1
#        objPacIn.opacity = 1
#        objPacStim.ori = varPacOri
#        objPacIn.ori = 0
#
#
#
#    while objClck.getTime()<np.sum(aryDur[0:i+1]):
#
#        if motionSwitch:
#            t = objClck.getTime()-np.sum(aryDur[0:i])
#            oriUpdate = np.sin(np.deg2rad(t*(360/varTr)*varFrq))*35
#            objPacStim.ori = varPacOri + oriUpdate
#            objPacIn.ori = oriUpdate
#
#        # update target
#        varCntTrgt= fnc_target(varCntTrgt)
#
#        # draw background
#        NoiseBackgrd.draw()
#
#        # draw pacman
#        objPacStim.draw()
#        objPacIn.draw()
#
#        # draw fixation point surround
#        objFixSrd.draw()
#
#        # draw fixation point
#        objFix.draw()
#
#        objWin.flip()
#
#        #handle key presses each frame
#        for keys in event.getKeys():
#            if keys[0]in ['escape','q']:
#                objWin.close()
#
#                core.quit()
#            elif keys in ['1']:
#                aryKeys = np.append([aryKeys],[objClck.getTime()])
#                logging.data(msg='Key1 pressed')
#
#
#.
#
#    # update counter
#    i = i + 1
#    motionSwitch = False
#
## log end of run
#logging.data('EndOfRun'+ unicode(dicExpInfo['Run']))
## close the eyevarTracker data file
#if ET:
#    vpx.VPX_SendCommand('dataFile_Close')
#
##%%
#"""TARGET DETECTION RESULTS"""
## calculate target detection results
## create an array 'targetDetected' for showing which aryTrgt were detected
#targetDetected = np.zeros(len(aryTrgt))
#if len(aryKeys) == 0:
#    # if no buttons were pressed
#    print "No keys were pressed/registered"
#    aryTrgtDet = 0
#else:
#    # if buttons were pressed:
#    for index, target in enumerate(aryTrgt):
#        for TimeKeyPress in aryKeys:
#            if float(TimeKeyPress)>=float(target) and float(TimeKeyPress)<=float(target)+2:
#                targetDetected[index] = 1
#
#logging.data('ArrayOfDetectedaryTrgt'+ unicode(targetDetected))
#print 'Array Of Detected aryTrgt:'
#print targetDetected
#
## number of detected aryTrgt
#aryTrgtDet = sum(targetDetected)
#logging.data('NumberOfDetectedaryTrgt'+ unicode(aryTrgtDet))
## detection ratio
#DetecvarTratio = aryTrgtDet/len(targetDetected)
#logging.data('RatioOfDetectedaryTrgt'+ unicode(DetecvarTratio))
#
## display target detection results to Subject_ID
#resultText = 'You have detected %i out of %i aryTrgt.' %(aryTrgtDet,len(aryTrgt))
#print resultText
#logging.data(resultText)
## also display a motivational slogan
#if DetecvarTratio >= 0.95:
#    feedbackText = 'Excellent! Keep up the good work'
#elif DetecvarTratio < 0.95 and DetecvarTratio > 0.85:
#    feedbackText = 'Well done! Keep up the good work'
#elif DetecvarTratio < 0.8 and DetecvarTratio > 0.65:
#    feedbackText = 'Please varTry to focus more'
#else:
#    feedbackText = 'You really need to focus more!'
#
#targetText = visual.TextStim(
#    win=objWin,
#    color='white',
#    height=0.5,
#    pos=(0.0, 0.0),
#    autoLog=False,
#    )
#targetText.setText(resultText+feedbackText)
#fleLog.write(unicode(resultText) + '\n')
#fleLog.write(unicode(feedbackText) + '\n')
#targetText.draw()
#objWin.flip()
#core.wait(5)
#objWin.close()
#
##%%
#"""SAVE DATA"""
## log important parameters
#try:
#    fleLog.write('varDurTaration=' + unicode(varDurTar) + '\n')
#    fleLog.write('aryKeys=' + unicode(aryKeys) + '\n')
#except:
#    print '(Important parameters could not be logged.)'
#
## create a pickle file with important arrays
#try:
#    os.chdir(outFolderName)
#    # create python dictionary containing important arrays
#    output = {'ExperimentName'     : dicExpInfo['Experiment_Name'],
#              'Date'               : dicExpInfo['Date'],
#              'SubjectID'          : dicExpInfo['Subject_ID'],
#              'Run_Number'         : dicExpInfo['Run'],
#              'Conditions'         : aryCon,
#              'aryDur'          : aryDur,
#              'KeyPresses'         : aryKeys,
#              'DetectedaryTrgt'    : targetDetected,
#              'EyevarTrackerUsed'     : dicExpInfo['EyevarTracker'],
#              }
#    # save dictionary as a pickle in output folder
#    misc.toFile(outFileName +'.pickle', output)
#    print 'Pickle data saved as: '+ outFileName +'.pickle'
#    print "***"
#    os.chdir(strPthMain)
#except:
#    print '(OUTPUT folder could not be created.)'
#
## create prt files for BV
#try:
#    os.chdir(prtFolderName)
#
#    aryDurMsec = (aryDur*1000)
#    aryDurMsec = aryDurMsec.astype(int)
#
#    # Set Conditions Names
#    CondNames = ['Rest',
#                 'PacmanStimStat',
#                 'PacmanStimDyn',
#                 ]
#
#    # Number code the aryCon, i.e. Fixation = -1, Static = 0, etc.
#    from collections import OrderedDict
#    stimTypeDict=OrderedDict()
#    stimTypeDict[CondNames[0]] = [1]
#    stimTypeDict[CondNames[1]] = [3]
#    stimTypeDict[CondNames[2]] = [4]
#
#
#    # Color code the aryCon
#    colourTypeDict ={
#        CondNames[0] : '64 64 64',
#        CondNames[1] : '255 0 0',
#        CondNames[2] : '0 255 0',
#        }
#
#    # Defining a function will reduce the code length significantly.
#    def idxAppend(iteration, enumeration, dictName, outDict):
#         if int(enumeration) in range(stimTypeDict[dictName][0],
#                                      stimTypeDict[dictName][-1]+1
#                                      ):
#            outDict = outDict.setdefault(dictName, [])
#            outDict.append( iteration )
#
#    # Reorganization of the protocol array (finding and saving the indices)
#    outIdxDict = {}  # an empty dictionary
#
#    # Please take a deeper breath.
#    for i, j in enumerate(aryCon):
#        for k in stimTypeDict:  # iterate through each key in dict
#            idxAppend(i, j, k, outIdxDict)
#
#    print outIdxDict
#
#    # Creation of the Brainvoyager .prt custom text file
#    prtName = '%s_%s_Run%s_%s.prt' %(dicExpInfo['Subject_ID'],dicExpInfo['Experiment_Name'],dicExpInfo['Run'], dicExpInfo['Date'])
#
#    file = open(prtName,'w')
#    header = ['FileVersion: 2\n',
#           'ResolutionOfTime: msec\n',
#           'Experiment: %s\n'%strExpNme,
#           'BackgroundColor: 0 0 0\n',
#           'TextColor: 255 255 202\n',
#           'TimeCourseColor: 255 255 255\n',
#           'TimeCourseThick: 3\n',
#           'ReferenceFuncColor: 192 192 192\n',
#           'ReferenceFuncThick: 2\n'
#           'NrOfConditions: %s\n' %svarTr(len(stimTypeDict))
#           ]
#
#    file.writelines(header)
#
#    # Conditions/predictors
#    for i in stimTypeDict:  # iterate through each key in stim. type dict
#        h = i
#
#        # Write the condition/predictor name and put the Nr. of repetitions
#        file.writelines(['\n',
#                         i+'\n',
#                         svarTr(len(outIdxDict[i]))
#                         ])
#
#        # iterate through each element, define onset and end of each condition
#        for j in outIdxDict[i]:
#            onset = int( sum(aryDurMsec[0:j+1]) - aryDurMsec[j] + 1 )
#            file.write('\n')
#            file.write(svarTr( onset ))
#            file.write(' ')
#            file.write(svarTr( onset + aryDurMsec[j]-1 ))
#        # contiditon color
#        file.write('\nColor: %s\n' %colourTypeDict[h])
#    file.close()
#    print 'PRT files saved as: ' + prtFolderName + '\\' + prtName
#    os.chdir(strPthMain)
#except:
#    print '(PRT files could not be created.)'

#%%
"""FINISH"""
core.quit()
