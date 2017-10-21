# -*- coding: utf-8 -*-
"""
Created on Sun Aug 23 13:15:32 2015

!!! This script needs to be placed in the 'scripts' folder to work properly !!!

@author: team awesome
"""

from __future__ import division # so that 1/3=0.333 instead of 1/3=0
from psychopy import visual, event, core,  monitors,logging, gui, data, misc
# from itertools import cycle  # import cycle if you want to flicker stimuli
import numpy as np
import os
from ctypes import *


#%%
""" GENERAL PARAMETERS"""
# set target length
targetDur = 0.8 # in s
TR = 2.832
HZ=2 # Oscillation frequency in one TR

#%%
""" SAVING and LOGGING """
# Store info about experiment and experimental run
expName = 'PacManStim'  # set experiment name here
expInfo = {
    u'run': u'01',
    u'participant': u'pilot',
    u'EyeTracker': [False, True] 
    }
    
# Create GUI at the beginning of exp to get more expInfo
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False: core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

# eyetracker set by user?
if expInfo['EyeTracker'] == 'True':
    ET = True
elif expInfo['EyeTracker'] == 'False':
    ET = False

# get current path and save to variable _thisDir
_thisDir = os.path.dirname(os.path.abspath(__file__)) 

# get parent path and move up one directory
str_path_parent_up = os.path.abspath(
    os.path.join(os.path.dirname( __file__ ), '..'))

# Name and create specific subject folder 
subjFolderName = str_path_parent_up + os.path.sep + '%s_SubjData' %(
    expInfo['participant'])
if not os.path.isdir(subjFolderName):
    os.makedirs(subjFolderName) 
# Name and create specific folder for logging results
logFolderName = subjFolderName + os.path.sep + 'Logging'
if not os.path.isdir(logFolderName):
    os.makedirs(logFolderName)
logFileName = logFolderName + os.path.sep +'%s_%s_Run%s_%s' %(
    expInfo['participant'],expInfo['expName'],expInfo['run'], expInfo['date'])
# Name and create specific folder for pickle output
outFolderName = subjFolderName + os.path.sep + 'Pickle'
if not os.path.isdir(outFolderName):
    os.makedirs(outFolderName)
outFileName = outFolderName + os.path.sep +'%s_%s_Run%s_%s' %(
    expInfo['participant'],expInfo['expName'],expInfo['run'], expInfo['date'])    
# Name and create specific folder for BV protocol files
prtFolderName = subjFolderName + os.path.sep + 'Protocols'
if not os.path.isdir(prtFolderName):
    os.makedirs(prtFolderName)
# Name and create specific folder for EyeTracker results
if ET:
    EyeTrFolderName = subjFolderName + os.path.sep + 'EyeTrackData'
    if not os.path.isdir(EyeTrFolderName):
        os.makedirs(EyeTrFolderName)

# save a log file and set level for msg to be received
logFile = logging.LogFile(logFileName+'.log', level=logging.INFO)
logging.console.setLevel(logging.WARNING) # console receives warnings/errors

# create array to log key pressed events
TimeKeyPressedArray = np.array([], dtype=float) 


#%%
"""MONITOR AND WINDOW"""
# set monitor information:
distanceMon = 99     # [99] in scanner
widthMon    = 30     # [30] in scanner
PixW        = 1920.0 # [1920.0] in scanner
PixH        = 1200.0 # [1200.0] in scanner

moni = monitors.Monitor('testMonitor', width=widthMon, distance=distanceMon)
moni.setSizePix([PixW, PixH]) # [1920.0, 1080.0] in psychoph lab

# log monitor info
logFile.write('MonitorDistance=' + unicode(distanceMon) + 'cm' + '\n')
logFile.write('MonitorWidth=' + unicode(widthMon) + 'cm' + '\n')
logFile.write('PixelWidth=' + unicode(PixW) + '\n')
logFile.write('PixelHeight=' + unicode(PixH) + '\n')

# set screen: 
myWin = visual.Window(
    size=(PixW, PixH),
    screen=0, 
    winType='pyglet', # winType : None, ‘pyglet’, ‘pygame’
    allowGUI=False,
    allowStencil=True,
    fullscr=True, # for psychoph lab: fullscr = True
    monitor=moni,
    color=[0.0,0.0,0.0],
    colorSpace='rgb',
    units='deg',
    blendMode='avg'
    )


#%%
"""CONDITIONS AND DURATIONS"""

# Load event matrix from text file:
# retrieve parent path and move up one directory
str_path_parent_up = os.path.abspath(
    os.path.join(os.path.dirname( __file__ ), '..'))
# join parts to find path to event matrix
str_path_eventmatrix = str_path_parent_up + os.path.sep + 'design_matrices' + \
    os.path.sep + 'PacMan_run_'+'%s' %(expInfo['run']) + '_txt_eventmatrix.txt'
# read in event matrix
ary_eventmatrix = np.loadtxt(str_path_eventmatrix, delimiter=' ',
                                unpack=False)
                                
# extract stimulus and rest coditions
conditions = np.transpose(ary_eventmatrix)[0][np.transpose(ary_eventmatrix)[0]!=2]
# make sure array is int
conditions = conditions.astype(int)
logFile.write('Conditions='+ unicode(conditions) + '\n')

# extract stimulus and rest onset times
conditionOnsets = np.transpose(ary_eventmatrix)[1][np.transpose(ary_eventmatrix)[0]!=2]
logFile.write('ConditionOnsets='+ unicode(conditionOnsets) + '\n')
                 
# extract durations of stimulus and rest
durations = np.transpose(ary_eventmatrix)[2][np.transpose(ary_eventmatrix)[0]!=2]
logFile.write('Durations='+ unicode(durations) + '\n')
 
# extract the time when targets should occur
targets = np.transpose(ary_eventmatrix)[1][np.transpose(ary_eventmatrix)[0]==2]
print ('targets: ')
print targets
logFile.write('Targets='+ unicode(targets) + '\n')

#%%
"""STIMULI"""
# A random noise background was shown that
# covered the whole display except the figures in the
# foreground (the luminance of each pixel was drawn
# from a Gaussian distribution with minimum luminance
# of zero and maximum luminance of 377.25 cd/m2, and
# then the resulting image was convolved with a 6 · 6
# uniform filtering kernel, see Figure 1).

# random noise background
ImagePath = str_path_parent_up + os.path.sep + 'Original_Noise.png'
NoiseBackgrd = visual.ImageStim(
    myWin,
    image=ImagePath,
    interpolate=False,
    texRes=128,
    )

# Both 'Pacman' and 'control' figure had a luminance value of 503 cd/m2.
# During the dynamic period, the figures oscillated sinusoidally with 
# a half period of 480 ms

# Pacman figure
pacmanColor = [0.0,0.0,0.0]
pacmanOri = 125
pacmanStim = visual.RadialStim(
    win=myWin,
    mask='none',
    units='deg',
    pos=(0, 0),
    size=(10),
    radialCycles=0,
    angularCycles=0,
    radialPhase=0,
    angularPhase=0,
    ori=pacmanOri,
    texRes=64,
    angularRes=100,
    visibleWedge=(0, 290),
    colorSpace='rgb',
    color=pacmanColor,
    interpolate=True,
    )

pacmanInner = visual.GratingStim(
    win=myWin,
    tex='none',
    units='deg',
    size=(0.5),
    mask='none',
    color=pacmanColor,
    colorSpace='rgb',
    ori=0
    )

# fixation dot
dotFix = visual.Circle(
    myWin,
    autoLog=False,
    name='dotFix',
    units='pix',
    radius=2,
    fillColor= [1.0,0.0,0.0],
    lineColor =[1.0,0.0,0.0],
    )

dotFixSurround = visual.Circle(
    myWin,
    autoLog=False,
    name='dotFix',
    units='pix',
    radius=7,
    fillColor=[0.5,0.5,0.0],
    lineColor =[0.0,0.0,0.0],
    )

# control text    
controlText = visual.TextStim(
    win=myWin,
    colorSpace='rgb',
    color=[1.0,1.0,1.0],
    height=0.5,
    pos=(0.0, -4.0),
    autoLog=False,
    )

# text at the beginning of the experiment
triggerText = visual.TextStim(
    win=myWin,
    colorSpace='rgb',
    color=[1.0,1.0,1.0],
    height=0.5, 
    text = 'Experiment will start soon. Waiting for scanner'
    )

#%%
"""TIME, TIMING AND CLOCKS"""
# parameters
totalTime = np.sum(durations)
logFile.write('TotalTime=' + unicode(totalTime) + '\n')

# give system time to settle before it checks screen refresh rate
core.wait(0.5)

# get screen refresh rate
refr_rate=myWin.getActualFrameRate() 

if refr_rate!=None:
    print 'refresh rate: %i' %refr_rate
    frameDur = 1.0/round(refr_rate)
    print 'actual frame dur: %f' %frameDur
else:
    # couldnt get reliable measure, guess
    frameDur = 1.0/60.0 
    print 'fake frame dur: %f' %frameDur

logFile.write('RefreshRate=' + unicode(refr_rate) + '\n')
logFile.write('FrameDuration=' + unicode(frameDur) + '\n')

# define clock
clock = core.Clock()
logging.setDefaultClock(clock)

#%%
"""FUNCTIONS"""

# target function
nrOfTargetFrames = int(targetDur/frameDur)
print "number of target frames"
print nrOfTargetFrames

# set initial value for target counter
mtargetCounter = nrOfTargetFrames+1;
def target(mtargetCounter):
    t = clock.getTime()
    # first time in target interval? reset target counter to 0!
    if sum(t >= targets) + sum(t< targets+frameDur) == len(targets)+1:
        mtargetCounter = 0
    # below number of target frames? display target!
    if mtargetCounter < nrOfTargetFrames:
        # change color fix dot surround to red
        dotFixSurround.fillColor = [0.5,0.0,0.0]
        dotFixSurround.lineColor = [0.5,0.0,0.0]
        if ET:
            TargetText = 'TargetFrame'+str(mtargetCounter)
            vpx.VPX_SendCommand('dataFile_InsertString ' + TargetText)        
    # above number of target frames? dont display target!
    else:
        # keep color fix dot surround yellow
        dotFixSurround.fillColor = [0.5,0.5,0.0]
        dotFixSurround.lineColor = [0.5,0.5,0.0]
        
    # update mtargetCounter    
    mtargetCounter = mtargetCounter + 1
    
    return mtargetCounter


#%%
"""SETUP FOR EYETRACKER"""
if ET:  
    # Eyetracker CONSTANTS (see vpx.h for full listing)
    VPX_STATUS_ViewPointIsRunning = 1
    EYE_A = 0
    VPX_DAT_FRESH = 2
    # load dll
    # psychoph lab
    #vpxDllPath = "C:\ViewPoint 2.9.2.5\Interfaces\Windows\ViewPointClient Ethernet Interface\VPX_InterApp.dll"
    # this has to be in same folder as viewPointClient.exe
    # scanner
    vpxDllPath = "C:\ViewPointClient\ViewPoint 2.8.6.21\Interfaces\Windows\ViewPointClient Ethernet Interface\VPX_InterApp.dll"
    
    
# CONNECT TO EYETRACKER
if ET:
    #  Load the ViewPoint library
    vpxDll = vpxDllPath
    if ( not os.access(vpxDll,os.F_OK) ):
        print("WARNING: Invalid vpxDll path; you need to edit the .py file")
        core.quit()
    cdll.LoadLibrary( vpxDll )
    vpx = CDLL( vpxDll )
    vpx.VPX_SendCommand('say "Hello from EVS Localiser Script" ')
    if ( vpx.VPX_GetStatus(VPX_STATUS_ViewPointIsRunning) < 1 ):
        print("ViewPoint is not running")
        core.quit()

# define ROI  
if ET:
    vpx.VPX_SendCommand('setROI_AllOff')
    # define central "fixation" ROI
    vpx.VPX_SendCommand('setROI_RealRect 1 0.45 0.45 0.55 0.55')


#%%
"""INIT EYETRACKER"""
#if ET:
#    #Allows asynchrously (on its own line) insert marker into datafile 
#    vpx.VPX_SendCommand('dataFile_AsynchMarkerData Yes')
#    #Allows synchrously (same line) insert string into datafile
#    vpx.VPX_SendCommand('datafile_AsynchStringData No')

if ET:
    # open and use new data file and give it a name
#    vpx.VPX_SendCommand('dataFile_NewUnique')
#    vpx.VPX_SendCommand('dataFile_NewName Laminae2p0')
    FileName =str(expInfo['participant'])+'_' + expInfo['expName']+'_'+'Run' + '_'+str(expInfo['run'])+'_'+str(expInfo['date'])+'.txt'
    vpx.VPX_SendCommand('dataFile_NewName ' + FileName)

    
#%%
"""RENDER_LOOP"""
# Create Counters
i = 0 # counter for blocks
#miniCounter = -1 # counter for mini blocks
# give system time to settle before stimulus presentation
core.wait(0.5)

#wait for scanner trigger
triggerText.draw()
myWin.flip()
event.waitKeys(keyList=['5'], timeStamped=False)
# set switch
motionSwitch = False
# reset clock
clock.reset()
logging.data('StartOfRun'+ unicode(expInfo['run']))

while clock.getTime()<totalTime:
    
    if conditions[i] == 1: # rest
        motionSwitch = False
        pacmanStim.opacity = 0
        pacmanInner.opacity = 0

    elif conditions[i] == 3: # pacman stim static
        motionSwitch = False
        pacmanStim.opacity = 1
        pacmanInner.opacity = 1
        pacmanStim.ori = pacmanOri
        pacmanInner.ori = 0
                
    elif conditions[i] == 4: # pacman stim move
        motionSwitch = True
        pacmanStim.opacity = 1
        pacmanInner.opacity = 1
        pacmanStim.ori = pacmanOri
        pacmanInner.ori = 0
  
    if ET:
        # insert Start marker S into datafile to mark start of condition
        vpx.VPX_SendCommand('dataFile_InsertMarker S') 
        BlockText = 'StartOfCondition'+str(conditions[i])
        vpx.VPX_SendCommand('dataFile_InsertString ' + BlockText)

    while clock.getTime()<np.sum(durations[0:i+1]):
        
        if motionSwitch:
            t = clock.getTime()-np.sum(durations[0:i])
            oriUpdate = np.sin(np.deg2rad(t*(360/TR)*HZ))*35
            pacmanStim.ori = pacmanOri + oriUpdate
            pacmanInner.ori = oriUpdate        

        # update target
        mtargetCounter= target(mtargetCounter)
        
        # draw background
        NoiseBackgrd.draw()
        
        # draw pacman
        pacmanStim.draw()
        pacmanInner.draw()
        
        # draw fixation point surround
        dotFixSurround.draw()
        
        # draw fixation point
        dotFix.draw()
        
        # draw control text
        # controlText.setText(clock.getTime())
        # controlText.draw()
        
        myWin.flip()
        
        #handle key presses each frame
        for keys in event.getKeys():
            if keys[0]in ['escape','q']:
                myWin.close()
                if ET:
                    vpx.VPX_SendCommand('dataFile_Close')                
                core.quit()  
            elif keys in ['1']:
                TimeKeyPressedArray = np.append([TimeKeyPressedArray],[clock.getTime()])
                logging.data(msg='Key1 pressed')
                if ET:
                    # insert marker B into datafile to mark button press
                    vpx.VPX_SendCommand('dataFile_InsertMarker B') 
                    BlockText = 'ButtonPress1'
                    vpx.VPX_SendCommand('dataFile_InsertString ' + BlockText)  


    # send marker to eye tracker
    if ET:
        # insert marker E into datafile to mark end of condition
        vpx.VPX_SendCommand('dataFile_InsertMarker E') 
        BlockText = 'EndOfCondition'+str(conditions[i])
        vpx.VPX_SendCommand('dataFile_InsertString ' + BlockText)
                      
    # update counter
    i = i + 1
    motionSwitch = False

# log end of run
logging.data('EndOfRun'+ unicode(expInfo['run']))
# close the eyetracker data file
if ET:
    vpx.VPX_SendCommand('dataFile_Close')

#%%
"""TARGET DETECTION RESULTS"""    
# calculate target detection results
# create an array 'targetDetected' for showing which targets were detected
targetDetected = np.zeros(len(targets))
if len(TimeKeyPressedArray) == 0:
    # if no buttons were pressed
    print "No keys were pressed/registered"
    targetsDet = 0 
else:
    # if buttons were pressed:
    for index, target in enumerate(targets):
        for TimeKeyPress in TimeKeyPressedArray:
            if float(TimeKeyPress)>=float(target) and float(TimeKeyPress)<=float(target)+2:
                targetDetected[index] = 1

logging.data('ArrayOfDetectedTargets'+ unicode(targetDetected))
print 'Array Of Detected Targets:'
print targetDetected
         
# number of detected targets
targetsDet = sum(targetDetected)
logging.data('NumberOfDetectedTargets'+ unicode(targetsDet))
# detection ratio
DetectRatio = targetsDet/len(targetDetected)
logging.data('RatioOfDetectedTargets'+ unicode(DetectRatio))

# display target detection results to participant
resultText = 'You have detected %i out of %i targets.' %(targetsDet,len(targets))
print resultText
logging.data(resultText)
# also display a motivational slogan
if DetectRatio >= 0.95:
    feedbackText = 'Excellent! Keep up the good work'
elif DetectRatio < 0.95 and DetectRatio > 0.85:
    feedbackText = 'Well done! Keep up the good work'
elif DetectRatio < 0.8 and DetectRatio > 0.65:
    feedbackText = 'Please try to focus more'
else:
    feedbackText = 'You really need to focus more!'
    
targetText = visual.TextStim(
    win=myWin,
    color='white',
    height=0.5,
    pos=(0.0, 0.0),
    autoLog=False,
    )
targetText.setText(resultText+feedbackText)
logFile.write(unicode(resultText) + '\n')
logFile.write(unicode(feedbackText) + '\n')
targetText.draw()
myWin.flip()
core.wait(5)
myWin.close()

#%%
"""SAVE DATA"""
# log important parameters
try:
    logFile.write('TargetDuration=' + unicode(targetDur) + '\n')
    logFile.write('TimeKeyPressedArray=' + unicode(TimeKeyPressedArray) + '\n')
except:
    print '(Important parameters could not be logged.)'    

# create a pickle file with important arrays
try:
    os.chdir(outFolderName)
    # create python dictionary containing important arrays
    output = {'ExperimentName'     : expInfo['expName'],
              'Date'               : expInfo['date'],
              'SubjectID'          : expInfo['participant'],
              'Run_Number'         : expInfo['run'],
              'Conditions'         : conditions,
              'Durations'          : durations,
              'KeyPresses'         : TimeKeyPressedArray,
              'DetectedTargets'    : targetDetected,
              'EyeTrackerUsed'     : expInfo['EyeTracker'],              
              }
    # save dictionary as a pickle in output folder
    misc.toFile(outFileName +'.pickle', output)
    print 'Pickle data saved as: '+ outFileName +'.pickle'
    print "***"
    os.chdir(_thisDir)
except:
    print '(OUTPUT folder could not be created.)'

# create prt files for BV   
try:
    os.chdir(prtFolderName)
    
    durationsMsec = (durations*1000)
    durationsMsec = durationsMsec.astype(int)
    
    # Set Conditions Names 
    CondNames = ['Rest',
                 'PacmanStimStat',
                 'PacmanStimDyn',
                 ]
    
    # Number code the conditions, i.e. Fixation = -1, Static = 0, etc.
    from collections import OrderedDict
    stimTypeDict=OrderedDict()
    stimTypeDict[CondNames[0]] = [1]
    stimTypeDict[CondNames[1]] = [3]
    stimTypeDict[CondNames[2]] = [4]


    # Color code the conditions
    colourTypeDict ={
        CondNames[0] : '64 64 64',
        CondNames[1] : '255 0 0',
        CondNames[2] : '0 255 0',
        }
    
    # Defining a function will reduce the code length significantly.
    def idxAppend(iteration, enumeration, dictName, outDict):
         if int(enumeration) in range(stimTypeDict[dictName][0],
                                      stimTypeDict[dictName][-1]+1
                                      ):
            outDict = outDict.setdefault(dictName, [])
            outDict.append( iteration )
    
    # Reorganization of the protocol array (finding and saving the indices)
    outIdxDict = {}  # an empty dictionary
    
    # Please take a deeper breath.
    for i, j in enumerate(conditions):
        for k in stimTypeDict:  # iterate through each key in dict
            idxAppend(i, j, k, outIdxDict)
    
    print outIdxDict
    
    # Creation of the Brainvoyager .prt custom text file
    prtName = '%s_%s_Run%s_%s.prt' %(expInfo['participant'],expInfo['expName'],expInfo['run'], expInfo['date'])

    file = open(prtName,'w')
    header = ['FileVersion: 2\n',
           'ResolutionOfTime: msec\n',
           'Experiment: %s\n'%expName,
           'BackgroundColor: 0 0 0\n',
           'TextColor: 255 255 202\n',
           'TimeCourseColor: 255 255 255\n',
           'TimeCourseThick: 3\n',
           'ReferenceFuncColor: 192 192 192\n',
           'ReferenceFuncThick: 2\n'
           'NrOfConditions: %s\n' %str(len(stimTypeDict))
           ]
    
    file.writelines(header)

    # Conditions/predictors
    for i in stimTypeDict:  # iterate through each key in stim. type dict
        h = i    
    
        # Write the condition/predictor name and put the Nr. of repetitions   
        file.writelines(['\n', 
                         i+'\n',
                         str(len(outIdxDict[i]))
                         ])
                         
        # iterate through each element, define onset and end of each condition    
        for j in outIdxDict[i]:
            onset = int( sum(durationsMsec[0:j+1]) - durationsMsec[j] + 1 )
            file.write('\n')
            file.write(str( onset ))
            file.write(' ')
            file.write(str( onset + durationsMsec[j]-1 ))
        # contiditon color
        file.write('\nColor: %s\n' %colourTypeDict[h])        
    file.close()
    print 'PRT files saved as: ' + prtFolderName + '\\' + prtName
    os.chdir(_thisDir)
except:
    print '(PRT files could not be created.)'
    
#%%
"""FINISH"""  
core.quit()


