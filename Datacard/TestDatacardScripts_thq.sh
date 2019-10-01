#!/bin/bash


#FILE125="/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_THQ.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_tth/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"
FILE125="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_syst/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5_THQ.root"
#FILE125="/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"
#FILE125="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_ggh/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_GG2H.root"
#FILE125="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_ggh/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_GG2H.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_tth/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"
EXT="Initial_thq"

INTLUMI=41.5
echo "Intlumi is $INTLUMI"

#PROCS="tth,ggH"
#PROCS="tth"
#PROCS="TTH,THQ"
PROCS="THQ"
echo "Procs are $PROCS"
#CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3,TTHLeptonicTag_0,TTHLeptonicTag_1"
#CATS="TTHLeptonicTag_0,TTHLeptonicTag_1,THQLeptonicTag"
CATS="THQLeptonicTag"
#CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3"
echo "Cats are $CATS"
SCALES=""

SMEARS=""
#./makeParametricModelDatacardFLASHgg.py -i $FILE125 -o Datacard_13TeV_${EXT}.txt -p $PROCS -c $CATS --isMultiPdf

./makeParametricModelDatacardFLASHgg_thq.py -i $FILE125 -o Datacard_13TeV_${EXT}.txt -p $PROCS -c $CATS --intLumi $INTLUMI --photonCatScales $SCALES --photonCatSmears $SMEARS --isMultiPdf --doSTXS
