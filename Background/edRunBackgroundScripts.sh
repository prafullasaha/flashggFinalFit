#!/bin/bash

FILE="/vols/cms/szenz/ws_862/output_GluGluHToGG_M120_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_862/output_VBFHToGG_M120_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_862/output_WHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ZHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_862/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_862/output_WHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ZHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_GluGluHToGG_M130_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_862/output_VBFHToGG_M130_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_862/output_WHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ZHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8.root,/vols/cms/szenz/ws_862/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8.root"

DATA="/vols/cms/szenz/ws_862/allData.root"

EXT="ReMiniAod_17Feb"
echo "Ext is $EXT"
PROCS="ggh,vbf,tth,wh,zh"
echo "Procs are $PROCS"
CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3,VBFTag_0,VBFTag_1,VBFTag_2,TTHHadronicTag,TTHLeptonicTag,ZHLeptonicTag,WHLeptonicTag,VHLeptonicLooseTag,VHHadronicTag,VHMetTag"
echo "Cats are $CATS"
INTLUMI=35.9
echo "Intlumi is $INTLUMI"
BATCH="IC"
echo "Batch is $BATCH"
QUEUE="hep.q"
echo "Batch is $QUEUE"

SIGFILE="/vols/build/cms/es811/FreshStart/Pass4/CMSSW_7_4_7/src/flashggFinalFit/Signal/outdir_${EXT}/CMS-HGG_sigfit_${EXT}.root"

#echo "./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData --unblind"
#./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData --unblind
echo "./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData"
./runBackgroundScripts.sh -i $DATA -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --sigFile $SIGFILE --isData
