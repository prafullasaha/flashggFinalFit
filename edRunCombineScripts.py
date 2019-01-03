#!/usr/bin/env python

#commands to send to the monolithic runFinalFits.sh script
from os import system, walk

justPrint = False
combineOnly = False

#justPrint = True
combineOnly = True

print 'About to run combined combine scripts'

#setup files 
#ext          = 'fullNewTest2016'
#ext          = 'fullNewTest2017'
ext          = 'fullNewTest2016plus2017'
print 'ext = %s'%ext

batch         = 'IC'
queue         = 'hep.q'
print 'batch %s'%batch
print 'queue %s'%queue

theCommand = './runFinalFitsScripts.sh --ext '+ext+' --batch '+batch+' --isData '
if combineOnly:      theCommand += ' --combineOnly '
if justPrint: print theCommand
else: system(theCommand)
