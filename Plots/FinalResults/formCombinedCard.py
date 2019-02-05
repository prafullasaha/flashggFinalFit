from os import system, listdir, getcwd
from ROOT import TFile
from numpy import sqrt

def run(command):
  print command
  system(command)

def renameSigObjects( fName, year ):
  '''Rename objects that are duplicated in both 2016 and 2017 workspaces'''
  inFile = TFile(fName,'update')
  ws = inFile.Get('wsig_13TeV')
  
  replacements = ['hggpdfsmrel', 'gaus', 'mean', 'dm', 'sig', 'sigma', 'frac']
  
  allPdfs = ws.allPdfs()
  nPdfs = len(allPdfs)
  pdf = allPdfs.createIterator()
  for i in range(nPdfs):
    if pdf.GetName().count('13TeV') and pdf.GetName().split('_')[0] in replacements:
      pdf.SetName(pdf.GetName().replace('13TeV','13TeV_%s'%year))
    pdf.Next()
  
  allFuncs = ws.allFunctions()
  nFuncs = len(allFuncs)
  func = allFuncs.createIterator()
  for i in range(nFuncs):
    if func.GetName().count('13TeV') and func.GetName().split('_')[0] in replacements:
      func.SetName(func.GetName().replace('13TeV','13TeV_%s'%year))
    func.Next()
  
  ws.Write()
  inFile.Close()

def renameBkgObjects( fName, year ):
  '''Rename objects that are duplicated in both 2016 and 2017 workspaces'''
  inFile = TFile(fName,'update')
  ws = inFile.Get('multipdf')
  
  replacements = ['env']
  
  allPdfs = ws.allPdfs()
  nPdfs = len(allPdfs)
  pdf = allPdfs.createIterator()
  for i in range(nPdfs):
    if pdf.GetName().count('13TeV') and pdf.GetName().split('_')[0] in replacements:
      pdf.SetName(pdf.GetName().replace('13TeV','13TeV_%s'%year))
    pdf.Next()
  
  allFuncs = ws.allFunctions()
  nFuncs = len(allFuncs)
  func = allFuncs.createIterator()
  for i in range(nFuncs):
    if func.GetName().count('13TeV') and func.GetName().split('_')[0] in replacements:
      func.SetName(func.GetName().replace('13TeV','13TeV_%s'%year))
    func.Next()
  
  ws.Write()
  inFile.Close()

def renameFiles(yearIndex=0, theDir='./'): 
  '''Add either 2016 or 2017 to input files for fit'''
  theYears = ['2016','2017']
  for fileName in listdir(theDir):
    if not 'CMS-HGG' in fileName: continue
    toSkip=False
    for year in theYears:
      if year in fileName: toSkip=True
    if toSkip: continue
    newName = fileName.replace('_mva', '_mva_%s'%theYears[yearIndex])
    mvCommand = 'mv %s/%s %s/%s'%(theDir, fileName, theDir, newName)
    run(mvCommand)
    #if newName.count('sigfit'):
    #  renameSigObjects(fName='%s/%s'%(theDir,newName), year=theYears[yearIndex])
    #elif newName.count('multipdf'):
    #  renameBkgObjects(fName='%s/%s'%(theDir,newName), year=theYears[yearIndex])

def editDatacard(theYear='2016'):
  '''Disambiguate names in the datacard between years. If doCorrelations is off, will duplicate all nuisances'''
  cardName = 'CMS-HGG_mva_%s_13TeV_datacard.txt'%theYear
  newCardName = cardName.replace(theYear, theYear+'_sensibleCorr')
  newLines = []
  correlated = ['BR_hgg',
  'CMS_hgg_scaleWeight_0','CMS_hgg_scaleWeight_1','CMS_hgg_scaleWeight_2','CMS_hgg_alphaSWeight_0',
  'CMS_hgg_pdfWeight_0','CMS_hgg_pdfWeight_1','CMS_hgg_pdfWeight_2','CMS_hgg_pdfWeight_3','CMS_hgg_pdfWeight_4','CMS_hgg_pdfWeight_5','CMS_hgg_pdfWeight_6','CMS_hgg_pdfWeight_7','CMS_hgg_pdfWeight_8','CMS_hgg_pdfWeight_9','CMS_hgg_pdfWeight_10','CMS_hgg_pdfWeight_11','CMS_hgg_pdfWeight_12','CMS_hgg_pdfWeight_13','CMS_hgg_pdfWeight_14','CMS_hgg_pdfWeight_15','CMS_hgg_pdfWeight_16','CMS_hgg_pdfWeight_17','CMS_hgg_pdfWeight_18','CMS_hgg_pdfWeight_19','CMS_hgg_pdfWeight_20','CMS_hgg_pdfWeight_21','CMS_hgg_pdfWeight_22','CMS_hgg_pdfWeight_23','CMS_hgg_pdfWeight_24','CMS_hgg_pdfWeight_25','CMS_hgg_pdfWeight_26','CMS_hgg_pdfWeight_27','CMS_hgg_pdfWeight_28','CMS_hgg_pdfWeight_29','CMS_hgg_pdfWeight_30','CMS_hgg_pdfWeight_31','CMS_hgg_pdfWeight_32','CMS_hgg_pdfWeight_33','CMS_hgg_pdfWeight_34','CMS_hgg_pdfWeight_35','CMS_hgg_pdfWeight_36','CMS_hgg_pdfWeight_37','CMS_hgg_pdfWeight_38','CMS_hgg_pdfWeight_39','CMS_hgg_pdfWeight_40','CMS_hgg_pdfWeight_41','CMS_hgg_pdfWeight_42','CMS_hgg_pdfWeight_43','CMS_hgg_pdfWeight_44','CMS_hgg_pdfWeight_45','CMS_hgg_pdfWeight_46','CMS_hgg_pdfWeight_47','CMS_hgg_pdfWeight_48','CMS_hgg_pdfWeight_49','CMS_hgg_pdfWeight_50','CMS_hgg_pdfWeight_51','CMS_hgg_pdfWeight_52','CMS_hgg_pdfWeight_53','CMS_hgg_pdfWeight_54','CMS_hgg_pdfWeight_55','CMS_hgg_pdfWeight_56','CMS_hgg_pdfWeight_57','CMS_hgg_pdfWeight_58','CMS_hgg_pdfWeight_59',
  'CMS_hgg_THU_ggH_Mu','CMS_hgg_THU_ggH_Res','CMS_hgg_THU_ggH_Mig01','CMS_hgg_THU_ggH_Mig12','CMS_hgg_THU_ggH_VBF2j','CMS_hgg_THU_ggH_VBF3j','CMS_hgg_THU_ggH_PT60','CMS_hgg_THU_ggH_PT120','CMS_hgg_THU_ggH_qmtop',
  'QCDscale_qqH','QCDscale_VH','QCDscale_ttH',
  'pdf_Higgs_qqbar','pdf_Higgs_gg','pdf_Higgs_ttH',
  'CMS_hgg_MET_JEC','CMS_hgg_MET_JER','CMS_hgg_MET_Unclustered','CMS_hgg_MET_PhotonScale',
  'CMS_hgg_JER_TTH','CMS_hgg_JEC_TTH',
  'CMS_hgg_phoIdMva','CMS_hgg_PreselSF',
  'MH']
  
  with open(cardName,'r') as inFile:
    lines = inFile.readlines()
    for line in lines:
      split = line.split()
      if len(split)>0:
        if split[0] == 'shapes': 
          #if not line.count('13TeV_%s'%theYear): line = line.replace('13TeV','13TeV_%s'%theYear,1) #FIXME why is this here??
          if not line.count( '_mva_%s'%theYear): line = line.replace('_mva', '_mva_%s'%theYear)
          if not line.count('hggpdfsmrel_13TeV_%s'%theYear): line = line.replace('hggpdfsmrel_13TeV','hggpdfsmrel_13TeV_%s'%theYear)
          if not line.count('13TeV_%s_bkgshape'%theYear): line = line.replace('13TeV_bkgshape','13TeV_%s_bkgshape'%theYear)
        elif split[0] == 'bin': 
          pass #FIXME
          #if not line.count('13TeV_%s'%theYear): line = line.replace('13TeV','13TeV_%s'%theYear)
        elif 'pdfindex' in split[0]:
          if not line.count('13TeV_%s'%theYear): line = line.replace('13TeV','13TeV_%s'%theYear)
      if len(split)>1:
        if split[1] == 'lnN' and not split[0] in correlated: 
          line = line.replace(split[0],split[0]+'_%s'%theYear)
        elif split[1] == 'param' and not split[0] in correlated: 
          pass
          #line = line.replace(split[0],split[0]+'_%s'%theYear) #FIXME
      newLines.append(line)
  with open(newCardName,'w') as outFile:
    for line in newLines: 
      outFile.write(line)

def doEditing():
  editDatacard()
  editDatacard(theYear='2017')

def doCardCombination():
  combCards = 'combineCards.py CMS-HGG_mva_201*sensibleCorr*datacard.txt > CMS-HGG_mva_13TeV_datacard.txt'
  run(combCards)

def main():
  filesOfInterest = ['CMS-HGG_sigfit_mva*.root','CMS-HGG_mva_13TeV_multipdf.root','CMS-HGG_mva_13TeV_datacard.txt']
  #filesOfInterest = ['CMS-HGG_mva_13TeV_datacard.txt']

  #copy and rename 2016+2017 files
  directory2016 = getcwd().replace('Comb','2016')
  run('mkdir 2016/')
  for files in filesOfInterest:
    copy2016 = 'cp %s/%s 2016/'%(directory2016,files)
    run(copy2016)
  renameFiles(theDir='2016')
  run('cp 2016/* .')
  directory2017 = getcwd().replace('Comb','2017')
  run('mkdir 2017/')
  for files in filesOfInterest:
    copy2017 = 'cp %s/%s 2017/'%(directory2017,files)
    run(copy2017)
  renameFiles(theDir='2017', yearIndex=1)
  run('cp 2017/* .')
  
  #rename categories and names in datacards
  doEditing()

  #combine the cards
  doCardCombination()

if __name__ == '__main__':
  main()
