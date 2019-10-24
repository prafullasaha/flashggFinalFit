#!/bin/bash


###############################################################################
#FILE="/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"


DATA="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOtHqTag/result_data/result_data17/allData.root"

#FILE125="/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"
###############################################################################

##############################################################################


#DATA="root://eoscms.cern.ch//eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/allData.root"

#FILE125="/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_GG2H.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_VBF.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_ZHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLL.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_WHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLNU.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_WHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_WH2HQQ.root,/eos/cms/store/user/rchatter/Et_Scales/HGG_OldSmear_NewFNUF_Legendary_All_Files/output_ZHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_ZH2HQQ.root"
##############################################################################


EXT="Initial_test"
#EXT="Test_EtScales_Mass_All_LegendaryCat"


echo "Ext is $EXT"
PROCS="GG2H"
echo "Procs are $PROCS"
#CATS="TTHLeptonicTag_0,TTHLeptonicTag_1,THQLeptonicTag"
CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3"
echo "Cats are $CATS"
INTLUMI=41.5
echo "Intlumi is $INTLUMI"
BATCH="HTCONDOR"
echo "Batch is $BATCH"
QUEUE="hep.q"
echo "Batch is $QUEUE"
BSWIDTH=3.400000
echo "Bswidth is $BSWIDTH"
NBINS=320
echo "Nbins is $NBINS"

#ps SCALES="HighR9EB,HighR9EE,LowR9EB,LowR9EE,Gain1EB,Gain6EB"
SCALES=""
#CALES="HighR9EB,HighR9EE,LowR9EB,LowR9EE"
#SCALES="HighR9EBLow,HighR9EBHigh,HighR9EELow,HighR9EEHigh,LowR9EBLow,LowR9EBHigh,LowR9EELow,LowR9EEHigh"
#SCALES="HighR9LowEB,HighR9HighEB,HighR9LowEE,HighR9HighEE,LowR9LowEB,LowR9HighEB,LowR9LowEE,LowR9HighEE"

#ps SCALESCORR="MaterialCentralBarrel,MaterialOuterBarrel,MaterialForward,FNUFEE,FNUFEB,ShowerShapeHighR9EE,ShowerShapeHighR9EB,ShowerShapeLowR9EE,ShowerShapeLowR9EB"
SCALESCORR=""
#ps SCALESGLOBAL="NonLinearity,Geant4"
SCALESGLOBAL=""
#SMEARS="HighR9EBPhi,HighR9EBRho,HighR9EEPhi,HighR9EERho,LowR9EBPhi,LowR9EBRho,LowR9EEPhi,LowR9EERho"
SMEARS="";
MASSLIST="120,125,130"
#MASSLIST="120,125,130"
MLOW=120
MHIGH=130
echo "Masslist is $MASSLIST"

SIGFILE="/afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_${EXT}/CMS-HGG_sigfit_${EXT}.root"

##################### Create background model ##############################
#./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData --unblind

./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData 
#./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData --bkgPlotsOnly
############################################################################

##################### Create datacard ######################################
#./runFinalFitsScripts.sh -i $FILE125 -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --datacardOnly --smears $SMEARS --scales $SCALES --scalesCorr $SCALESCORR --scalesGlobal $SCALESGLOBAL --doSTXS
############################################################################
#./runFinalFitsScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --combineOnly
#./runFinalFitsScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --combinePlotsOnly
