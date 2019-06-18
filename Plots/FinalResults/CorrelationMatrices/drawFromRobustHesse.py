from shanePalette import set_color_palette
from usefulStyle import drawCMS, drawEnPu, setCanvas, formatHisto
from collections import OrderedDict as od
import ROOT as r

r.gROOT.SetBatch(True)
r.gStyle.SetNumberContours(500)

lumi = 77.4

#exts = ['Stage0','Stage1','Stage1Minimal']
exts = od()
#exts['Stage1']        = ['r_ggH_0J', 'r_ggH_1J_low', 'r_ggH_1J_med', 'r_ggH_1J_high', 'r_ggH_GE2J', 'r_ggH_BSM', 'r_qqH' ]
exts['Stage1Minimal'] = ['r_ggH_0J',
                         'r_ggH_1J_low', 'r_ggH_1J_med', 'r_ggH_1J_high', 'r_ggH_1J_BSM', 
                         'r_ggH_GE2J_low', 'r_ggH_GE2J_med', 'r_ggH_GE2J_high', 'r_ggH_2J_BSM', 'r_ggH_VBFTOPO', 
                         'r_qqH_2J', 'r_qqH_3J', 'r_qqH_Rest']

def prettyProc( proc ):
  if proc.startswith('r_'): proc = proc.split('r_')[1]
  if proc.startswith('GG2H_'):
    name = 'ggH '
    proc = proc.split('GG2H_')[1]
    proc = proc.replace('VBFTOPO_JET3VETO','VBF-like 2J')
    proc = proc.replace('VBFTOPO_JET3','VBF-like 3J')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_60_120','med')
    proc = proc.replace('PTH_120_200','high')
    proc = proc.replace('PTH_GT200','BSM')
    proc = proc.replace('GE2J','2J')
    proc = proc.replace('_',' ')
    name = name + proc
  elif proc.startswith('VBF_'):
    #name = 'VBF '
    name = 'qqH '
    proc = proc.split('VBF_')[1]
    proc = proc.replace('PTJET1_GT200','BSM')
    proc = proc.replace('VBFTOPO','')
    proc = proc.replace('JET3VETO','2J-like')
    proc = proc.replace('JET3','3J-like')
    proc = proc.replace('VH2JET','VH-like')
    #proc = proc.replace('REST','rest')
    proc = proc.replace('REST','other')
    proc = proc.replace('_',' ')
    name = name + proc
  elif proc.startswith('qqH_'):
    #name = 'VBF '
    name = 'qqH '
    proc = proc.split('qqH_')[1]
    #proc = proc.replace('REST','rest')
    proc = proc.replace('Rest','other')
    proc = proc.replace('2J','2J-like')
    proc = proc.replace('3J','3J-like')
    proc = proc.replace('_',' ')
    name = name + proc
  else:
    name = ''
    proc = proc.replace('VBFTOPO_JET3VETO','VBF-like 2J')
    proc = proc.replace('VBFTOPO_JET3','VBF-like 3J')
    proc = proc.replace('VBFTOPO','VBF-like')
    proc = proc.replace('PTJET1_GT200','BSM')
    proc = proc.replace('JET3VETO','2J-like')
    proc = proc.replace('JET3','3J-like')
    proc = proc.replace('VH2JET','VH-like')
    #proc = proc.replace('REST','rest')
    proc = proc.replace('REST','other')
    proc = proc.replace('Rest','other')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_60_120','med')
    proc = proc.replace('PTH_120_200','high')
    proc = proc.replace('PTH_GT200','BSM')
    proc = proc.replace('GE2J','2J')
    proc = proc.replace('_',' ')
    name = name + proc
  return name

for ext,pois in exts.iteritems():
  fileName = '%s/Expected/robustHesse_robustHesse.root'%ext
  #fileName = '%s/Pass5/robustHesse_robustHesse.root'%ext
  #fileName = '%s/robustHesse_robustHesseObserved.root'%ext
  inFile = r.TFile(fileName,'READ')
  theMatrix = inFile.Get('h_correlation')
  theList   = inFile.Get('floatParsFinal')

  pars = od()
  for iPar,par in enumerate(theList):
    if iPar==len(theList)-1: break
    if not par.GetName().startswith('r_'): continue
    pars[par.GetName()] = iPar
  nPars = len(pars.keys())
  print 'Procesing the following %g parameters:'%nPars
  for par in pars.keys(): print par
  revPars = {i:name for name,i in pars.iteritems()}

  theHist = r.TH2F('corr_%s'%ext, '', nPars, -0.5, nPars-0.5, nPars, -0.5, nPars-0.5)
  theMap = {}

  for iBin,iPar in enumerate(pars.values()):
    for jBin,jPar in enumerate(pars.values()):
      proc = theMatrix.GetXaxis().GetBinLabel(iPar+1)
      #print 'Got proc %s, expecting proc %s'%(proc, revPars[iPar])
      theVal = theMatrix.GetBinContent(iPar+1,jPar+1)
      #print 'Value for correlation between %s and %s is %.3f'%(revPars[iPar],revPars[jPar],theVal)
      theMap[(revPars[iPar],revPars[jPar])] = theVal

  for iBin,iPar in enumerate(pois):
    for jBin,jPar in enumerate(pois):
      theHist.GetXaxis().SetBinLabel(iBin+1, prettyProc(iPar))
      theHist.GetYaxis().SetBinLabel(jBin+1, prettyProc(jPar))
      #print 'Filling correlation for %s and %s of %.3f'%(iPar, jPar, theMap[(iPar,jPar)])
      theHist.Fill(iBin, jBin, theMap[(iPar,jPar)])

  print 'Final correlation map used is:'
  print theMap

  set_color_palette('frenchFlag')
  r.gStyle.SetNumberContours(500)
  r.gStyle.SetPaintTextFormat('1.2f')

  #canv = r.TCanvas('canv','canv')
  canv = setCanvas()
  formatHisto(theHist)
  theHist.GetXaxis().SetTickLength(0.)
  theHist.GetXaxis().SetLabelSize(0.05)
  theHist.GetYaxis().SetTickLength(0.)
  theHist.GetYaxis().SetLabelSize(0.05)
  theHist.GetZaxis().SetRangeUser(-1.,1.)
  theHist.GetZaxis().SetTickLength(0.)
  if ext.count('Minimal'): 
    theHist.GetXaxis().SetLabelSize(0.04)
    theHist.GetYaxis().SetLabelSize(0.04)

  theHist.Draw('colz,text')
  drawCMS(True)
  drawEnPu(lumi='%2.1f fb^{-1}'%lumi)
  #canv.Print('Plots/corrMatrixFormal_%s.png'%ext)
  #canv.Print('Plots/corrMatrixFormal_%s.pdf'%ext)
  canv.Print('PlotsTemp/corrMatrixFormal_Obs%s.png'%ext)
  canv.Print('PlotsTemp/corrMatrixFormal_Obs%s.pdf'%ext)
