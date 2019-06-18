#!/usr/bin/env python

#commands to send to the monolithic runFinalFits.sh script
from os import system, walk

justPrint = False
combineOnly = False

#justPrint = True
combineOnly = True

print 'About to run combined combine scripts'

#setup files 
#ext          = 'preappFinal2016'
#ext          = 'preappFinal2017'
#ext          = 'preappFinal2016plus2017'
ext          = 'approvalFinal2016plus2017'
print 'ext = %s'%ext

#misc config
lumi          = '77.4'
batch         = 'IC'
queue         = 'hep.q'
print 'batch %s'%batch
print 'queue %s'%queue

theCommand = './runFinalFitsScripts.sh --ext '+ext+' --batch '+batch+' --isData '+' --intLumi '+lumi
if combineOnly:      theCommand += ' --combineOnly '
if justPrint: print theCommand
else: system(theCommand)
