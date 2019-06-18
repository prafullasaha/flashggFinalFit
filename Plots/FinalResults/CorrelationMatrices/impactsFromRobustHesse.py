from shanePalette import set_color_palette
from usefulStyle import drawCMS, drawEnPu, setCanvas, formatHisto
from collections import OrderedDict as od
from operator import itemgetter
from os import system, path
from numpy import sqrt
import ROOT as r

r.gROOT.SetBatch(True)
r.gStyle.SetNumberContours(500)

lumi = 77.4

fits  = od()
fits['Inclusive'] = ['r']
fits['Stage0'] = ['r_qqH', 'r_ggH']
fits['Stage1'] = reversed(['r_qqH', 'r_ggH_BSM', 'r_ggH_GE2J', 'r_ggH_1J_high', 'r_ggH_1J_med', 'r_ggH_1J_low', 'r_ggH_0J'])
fits['Stage1Minimal'] = reversed(['r_qqH_Rest', 'r_qqH_3J', 'r_qqH_2J', 
                            'r_ggH_VBFTOPO', 'r_ggH_2J_BSM', 'r_ggH_GE2J_high', 'r_ggH_GE2J_med', 'r_ggH_GE2J_low', 
                            'r_ggH_1J_BSM', 'r_ggH_1J_high', 'r_ggH_1J_med', 'r_ggH_1J_low', 
                            'r_ggH_0J'])

with open('impacts.tex','w') as outFile:

  printStr = '\\documentclass{article} \n'
  printStr += '\\usepackage[utf8]{inputenc} \n'
  printStr += '\\usepackage{multirow} \n'
  printStr += '\\usepackage[usenames, dvipsnames]{color} \n'
  printStr += '\\usepackage{amsmath,amssymb} \n'
  printStr += '\\usepackage[a4paper, total={6in, 8in}]{geometry} \n'
  printStr += '\n\n'
  printStr += '\\begin{document} \n'
  outFile.write(printStr)

  for fit,pois in fits.iteritems():
    fileName = '%s/robustHesse_robustHesse.root'%fit
    #fileName = '%s/Pass4/robustHesse_robustHesse.root'%fit
    inFile = r.TFile(fileName,'READ')
    theMatrix = inFile.Get('h_correlation')
    theCovMatrix = inFile.Get('h_covariance')
    theList   = inFile.Get('floatParsFinal')
    nPars = len(theList)
  
    for poi in pois:
      pars = {}
      poiIndex = None
      #print 'Processing the %g parameters for the POI %s'%(nPars, poi)
      for iPar,par in enumerate(theList):
        if iPar==len(theList)-1: break
        if par.GetName() == poi: poiIndex = iPar

      poiUnc = sqrt(theCovMatrix.GetBinContent(poiIndex+1,poiIndex+1))
      print 'Processing poi %s, whose uncertainty is %.3f'%(poi, poiUnc)
  
      for iBin in range(nPars):
        par = theMatrix.GetXaxis().GetBinLabel(iBin+1)
        if par.startswith('shapeBkg') or par.startswith('env_pdf') or par.startswith('r_') or par=='r': continue
        theCorr = theMatrix.GetBinContent(iBin+1,poiIndex+1)
        theVal = theCorr * poiUnc
        if poi.count('qqH') and par.count('scale_j'):
          print 'Correlation between %s by %s is %.3f'%(par,poi,theCorr)
          print 'And the uncertainty on  %s   is %.3f'%(poi,poiUnc)
          print 'Value for impact on %s by %s is %.3f'%(par,poi,theVal)
        if abs(theVal) < 0.005: continue
        pars[par] = (theVal,abs(theVal))
  
      printStr = '\\begin{table} \n'
      printStr += '  \\centering \n'
      printStr += '  \\begin{tabular}{ r | c } \n'
      printStr += '  \\hline \n'
      printStr += '  Parameter & Impact on %s in %s fit \\\\ \n'%(poi.replace('r_','').replace('_',' '), fit)
      printStr += '  \\hline \n'
  
      pars = sorted(pars.items(), key=lambda v : v[1][1], reverse=True)
      for par,val in pars:
        printStr +=  '  %s & %.2f \\\\ \n'%(par.replace('_',' '),val[0])
  
      printStr += '  \\hline \n'
      printStr += '  \\end{tabular} \n'
      printStr += '\\end{table} \n'
      printStr += '\n\n\\clearpage\n\n'
      outFile.write(printStr)
  
  printStr = '\\end{document}'
  outFile.write(printStr)

system('pdflatex impacts.tex')
system('rm impacts.{log,aux,tex}')
if not path.isdir('../Tables'): system('mkdir -p ../Tables')
system('mv impacts.pdf ../Tables')
