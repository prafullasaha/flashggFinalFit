from os import system, popen
from collections import OrderedDict as od
import ROOT as r

r.gROOT.SetBatch(True)

from optparse import OptionParser
parser = OptionParser()
parser.add_option("-d","--datacard", help="Input datacard")
parser.add_option("-p","--pois",default="",help="Comma-separated list of POIs")
parser.add_option("-r","--ranges",default="",help="POI ranges in form low1:high1,low2:high2,...")
parser.add_option("-n","--name",default="",help="name for the output folder")
parser.add_option("--submit",default=False,action="store_true",help="Submit to batch")
parser.add_option("--doInitialFits",default=False,action="store_true",help="do initial fits to get best-fit and uncerts")
parser.add_option("--doCorrelationFits",default=False,action="store_true",help="perform fits with POIs frozen at pm one sigma to get correlations")
parser.add_option("--plotMatrix",default=False,action="store_true",help="plot the correlation matrix")
parser.add_option("--dryRun",default=False,action="store_true",help="don't actually submit the jobs")
parser.add_option("--expected",default=False,action="store_true",help="run expected rather than observed fits")
(opts,args)=parser.parse_args()

datacard = opts.datacard
pois     = opts.pois.split(',')
ranges   = opts.ranges.split(',')
nPOIs = len(pois)
print
print 'Running on datacard %s with POIs %s'%(datacard, pois)
print

centrals = {}
variations = {}

baseCombineCommand = 'combine '+datacard+' -M MultiDimFit --floatOtherPOIs 1 --saveInactivePOI 1 --setParameterRanges '
for i,rang in enumerate(ranges):
  rang = rang.replace(':',',')
  baseCombineCommand += '%s=%s:'%(pois[i], rang)
baseCombineCommand = baseCombineCommand[:-1] + ' '
if opts.expected: baseCombineCommand += '--expectSignal 1 -t -1'
print 'Base combine command is'
print baseCombineCommand
print

doInitialFits = opts.doInitialFits
doCorrelationFits = opts.doCorrelationFits
plotMatrix = opts.plotMatrix

if opts.submit:
  if not opts.name: opts.name = datacard.split('_')[1].split('.root')[0]
  dirName = 'CorrMatrix_%s'%opts.name
  system('mkdir -p %s'%dirName)
  system('cp CMS-HGG*.root %s'%dirName)
  system('cp %s %s'%(datacard,dirName))
  absDirName = popen('pwd').read().replace('\n','/') + dirName
  print 'full directory name is %s'%absDirName
  print

#initial fits to get central and pm one sigma values
if doInitialFits:
  print 'Performing initial fits'
  for poi in pois:
    theCommand = baseCombineCommand + ' -P %s -n _initial_%s --algo singles --cl 0.68 --robustFit 1'%(poi, poi)
    if not opts.submit:
      print theCommand
      if not opts.dryRun: system(theCommand)
    else:
      subName = 'sub_initial_%s.sh'%(poi)
      subFile = open('%s/%s'%(dirName,subName), 'w')
      subFile.write('#!/bin/bash \n')
      subFile.write('cd %s \n'%absDirName)
      subFile.write('eval `scramv1 runtime -sh` \n')
      subFile.write('touch %s.run \n'%subName)
      subFile.write('if ( %s ) then \n  touch %s.done \n'%(theCommand, subName))
      subFile.write('else \n  touch %s.fail \n'%(subName))
      subFile.write('fi \n')
      subFile.write('rm -f %s.run \n'%subName)
      subFile.close()
      if not opts.dryRun:
        subCommand = 'qsub -o %s/%s.log -e %s/%s.err -q hep.q -l h_rt=3:0:0 %s/%s'%(absDirName,subName,absDirName,subName,absDirName,subName)
        print
        print subCommand
        system(subCommand)

#fits with POI fixed to plus/minus one sigma
if doCorrelationFits: print 'Performing correlation fits'
if doCorrelationFits or plotMatrix:
  for poi in pois:
    tempFileName = 'higgsCombine_initial_%s.MultiDimFit.mH120.root'%poi
    if opts.submit: tempFileName = '%s/'%dirName + tempFileName
    tempFile = r.TFile(tempFileName, 'READ')
    tempTree = tempFile.Get('limit')
    tempTree.GetEntry(0)
    centrals[poi] = getattr(tempTree, poi)
    variations[poi] = [-9999.,9999.]
    for shift in ['Up','Down']:
      tempTree.GetEntry( 1 + shift.count('Up') )
      tempVal = getattr(tempTree, poi)
      variations[poi][shift.count('Up')] = tempVal
      theCommand = baseCombineCommand + ' -P %s -n _shift%s_%s --setParameters %s=%1.4f --freezeParameters %s '%(poi, shift, poi, poi, tempVal, poi)
      if doCorrelationFits:
        if not opts.submit:
          print theCommand
          if not opts.dryRun: system(theCommand)
        else:
          subName = 'sub_corrFit_%s.sh'%(poi)
          subFile = open('%s/%s'%(dirName,subName), 'w')
          subFile.write('#!/bin/bash \n')
          subFile.write('cd %s \n'%absDirName)
          subFile.write('eval `scramv1 runtime -sh` \n')
          subFile.write('touch %s.run \n'%subName)
          subFile.write('if ( %s ) then \n  touch %s.done \n'%(theCommand, subName))
          subFile.write('else \n  touch %s.fail \n'%(subName))
          subFile.write('fi \n')
          subFile.write('rm -f %s.run \n'%subName)
          subFile.close()
          if not opts.dryRun:
            subCommand = 'qsub -o %s/%s.log -e %s/%s.err -q hep.q -l h_rt=3:0:0 %s/%s'%(absDirName,subName,absDirName,subName,absDirName,subName)
            print subCommand
            system(subCommand)
    tempFile.Close()

if plotMatrix:
  print 'Will now plot the correlation matrix'
  theMatrix = r.TH2F( 'corrMatrix', 'corrMatrix', nPOIs, -0.5, nPOIs-0.5, nPOIs, -0.5, nPOIs-0.5 )
  for i,poi in enumerate(pois):
    upName   = 'higgsCombine_shiftUp_%s.MultiDimFit.mH120.root'%poi
    downName = 'higgsCombine_shiftDown_%s.MultiDimFit.mH120.root'%poi
    if opts.submit:
      upName   = '%s/'%dirName + upName
      downName = '%s/'%dirName + downName
    upFile   = r.TFile(upName, 'READ')
    downFile = r.TFile(downName, 'READ')
    upTree   = upFile.Get('limit')
    downTree = downFile.Get('limit')
    upTree.GetEntry(0)
    downTree.GetEntry(0)
    sigmaPOI = 0.5 * (variations[poi][1] - variations[poi][0])
    for j,depPOI in enumerate(pois):
      upVal   = getattr(upTree, depPOI)
      downVal = getattr(downTree, depPOI)
      sigmaDepPOI = 0.5 * (variations[depPOI][1] - variations[depPOI][0])
      corr = 0.5 * (upVal - downVal) / sigmaDepPOI
      print 'corr between real POI %s and dependent POI %s is %1.3f'%(poi, depPOI, corr)
      theMatrix.Fill(i, j, corr)
    upFile.Close()
    downFile.Close()
  canv = r.TCanvas('canv','canv')
  theMatrix.Draw('colz')
  canv.Print('corrMatrix.png')
  canv.Print('corrMatrix.pdf')

print
