#!/bin/bash

#FILE="/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"

FILE="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5_THQ.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5_THQ.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5_THQ.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_tth/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_tth/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_WOsyst/result_tth/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"

#EFFACCFILE="/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_GluGluHToGG_M120_13TeV_amcatnloFXFX_pythia8_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_VBFHToGG_M120_13TeV_amcatnlo_pythia8_VBF.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_WH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLL.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLNU.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_ZH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_VBF.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_WH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLL.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLNU.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_ZH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_GluGluHToGG_M130_13TeV_amcatnloFXFX_pythia8_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_VBFHToGG_M130_13TeV_amcatnlo_pythia8_VBF.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_WH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLL.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_WHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_QQ2HLNU.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ZHToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_ZH2HQQ.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"

DATA="/eos/user/p/prsaha/flashggFinalFit_inputs/result_data17/allData.root"

#FILE125="/eos/user/p/prsaha/flashggFinalFit_inputs/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"

FILE125="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result_syst/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5_THQ.root"

UEPSFILE="/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_CUETP8M1Down_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_CUETP8M1Up_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_CUETP8M1Down_VBF.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_CUETP8M1Up_VBF.root,UEPS,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_DownPS_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_UpPS_GG2H.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_DownPS_VBF.root,/vols/cms/es811/FinalFits/ws_ReweighAndNewggHweights_ueps/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8_UpPS_VBF.root"

EXT="Initial_tHq"
echo "Ext is $EXT"
PROCS="THQ"
echo "Procs are $PROCS"
CATS="THQLeptonicTag"
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

#SCALES="HighR9EB,HighR9EE,LowR9EB,LowR9EE,Gain1EB,Gain6EB"
SCALES=""
#SCALESCORR="MaterialCentralBarrel,MaterialOuterBarrel,MaterialForward,FNUFEE,FNUFEB,ShowerShapeHighR9EE,ShowerShapeHighR9EB,ShowerShapeLowR9EE,ShowerShapeLowR9EB"
SCALESCORR=""
#SCALESGLOBAL="NonLinearity:UntaggedTag_0:2,Geant4"
SCALESGLOBAL=""
#SMEARS="HighR9EBPhi,HighR9EBRho,HighR9EEPhi,HighR9EERho,LowR9EBPhi,LowR9EBRho,LowR9EEPhi,LowR9EERho"
SMEARS=""
MASSLIST="120,125,130"
#MASSLIST="120,125,130"
MLOW=120
MHIGH=130
echo "Masslist is $MASSLIST"

SIGFILE="/afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_${EXT}/CMS-HGG_sigfit_${EXT}.root"

./runFinalFitsScripts.sh -i $FILE125 -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --smears $SMEARS --scales $SCALES --scalesCorr $SCALESCORR --scalesGlobal $SCALESGLOBAL --combineOnly  #--uepsFile $UEPSFILE 

#./runFinalFitsScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --combineOnly
#./runFinalFitsScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --dataFile $DATA --isData --combinePlotsOnly

#./yieldsTableColour.py -w $FILE125 -s Signal/signumbers_${EXT}.txt -u Background/CMS-HGG_multipdf_$EXT.root --factor $INTLUMI -f $CATS --order "Total,GG2H,VBF,TTH,testBBH,testTHQ,testTHW,QQ2HLNU,QQ2HLL,WH2HQQ,ZH2HQQ:Untagged Tag 0,Untagged Tag 1,Untagged Tag 2,Untagged Tag 3,VBF Tag 0,VBF Tag 1,VBF Tag 2,TTH Hadronic Tag,TTH Leptonic Tag,ZH Leptonic Tag,WH Leptonic Tag,VH LeptonicLoose Tag,VH Hadronic Tag,VH Met Tag,Total"
#./yieldsTableColour.py -w $FILE125 -s Signal/signumbers_${EXT}.txt -u Background/CMS-HGG_multipdf_$EXT.root --factor $INTLUMI -f $CATS --order "Total,GG2H,VBF,TTH,testBBH,testTHQ,testTHW,WH2HQQ,QQ2HLNU,ZH2HQQ,QQ2HLL:Untagged Tag 0,Untagged Tag 1,Untagged Tag 2,Untagged Tag 3,VBF Tag 0,VBF Tag 1,VBF Tag 2,TTH Hadronic Tag,TTH Leptonic Tag,ZH Leptonic Tag,WH Leptonic Tag,VH LeptonicLoose Tag,VH Hadronic Tag,VH Met Tag,Total"
#./makeEffAcc.py $EFFACCFILE Signal/outdir_${EXT}/sigfit/effAccCheck_all.root $INTLUMI
