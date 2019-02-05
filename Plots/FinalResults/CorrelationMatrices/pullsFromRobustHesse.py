from shanePalette import set_color_palette
from usefulStyle import drawCMS, drawEnPu, setCanvas, formatHisto
from collections import OrderedDict as od
import ROOT as r

r.gROOT.SetBatch(True)
r.gStyle.SetNumberContours(500)

lumi = 77.4

#exts = ['Inclusive','Stage0','Stage1','Stage1Minimal']
exts = ['Stage1','Stage1Minimal']

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
    name = 'VBF '
    proc = proc.split('VBF_')[1]
    proc = proc.replace('PTJET1_GT200','BSM')
    proc = proc.replace('VBFTOPO','')
    proc = proc.replace('JET3VETO','2J-like')
    proc = proc.replace('JET3','3J-like')
    proc = proc.replace('VH2JET','VH-like')
    proc = proc.replace('REST','rest')
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
    proc = proc.replace('REST','rest')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_0_60','low')
    proc = proc.replace('PTH_60_120','med')
    proc = proc.replace('PTH_120_200','high')
    proc = proc.replace('PTH_GT200','BSM')
    proc = proc.replace('GE2J','2J')
    proc = proc.replace('_',' ')
    name = name + proc
  return name

for ext in exts:
  fileName = '%s/multidimfit_robustHesse.txt'%ext
  #fileName = '%s/Pass4/multidimfit_robustHesse.txt'%ext
  print 'Pulls and constraints for the %s fit'%ext
  with open(fileName) as inFile:
    for line in inFile.readlines():
      split = line.split()
      if not len(split)==4: exit('EXITING invalid input line')
      par = str(split[0])
      if par.startswith('shapeBkg') or par.startswith('env_pdf') or par.startswith('r_'): continue
      if par.count('pdfWeight'): continue
      val = float(split[1])
      err = float(split[3])
      #toPrint = par.ljust(50)
      toPrint = '%s & '%par.replace('_',' ')
      if val < 0.:
        #toPrint += '%.2f +/- %.2f'%(val, err)
        toPrint += '%.2f & %.2f \\\\'%(val, err)
      elif val > 0.:
        #toPrint += ' %.2f +/- %.2f'%(val, err)
        toPrint += ' %.2f & %.2f \\\\'%(val, err)
      print toPrint
  print 
  print
