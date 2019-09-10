#!/bin/bash


##################################################******************************************************#############################################
#FILE="/eos/user/p/prsaha/flashggFinalFit_inputs/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/eos/user/p/prsaha/flashggFinalFit_inputs/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8.root,/eos/user/p/prsaha/flashggFinalFit_inputs/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8.root,/eos/user/p/prsaha/flashggFinalFit_inputs/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8.root"
FILE="/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root"
##########################################################################################################################################################

#EXT="Test_HTCondor"
#EXT="Test_EtScales_Mass_All_Update2Cat"
#EXT="Test_EtScales_Mass_All_LegendaryCat"
EXT="Initial_tHq"
echo "Ext is $EXT"

OUTDIR="outdir_$EXT"

PROCS="TTH,THQ"
#PROCS="GG2H,VBF,TTH,QQ2HLNU,WH2HQQ"
#PROCS="GG2H,VBF,TTH,QQ2HLL,ZH2HQQ"
echo "Procs are $PROCS"
#CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3,VBFTag_0,VBFTag_1,VBFTag_2,TTHHadronicTag,TTHLeptonicTag,ZHLeptonicTag,WHLeptonicTag,VHLeptonicLooseTag,VHHadronicTag,VHMetTag"
CATS="TTHLeptonicTag_0,TTHLeptonicTag_1,THQLeptonicTag"

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

SCALES="HighR9EB,HighR9EE,LowR9EB,LowR9EE,Gain1EB,Gain6EB"
#SCALES="HighR9EB,HighR9EE,LowR9EB,LowR9EE"
#SCALES="HighR9EBLow,HighR9EBHigh,HighR9EELow,HighR9EEHigh,LowR9EBLow,LowR9EBHigh,LowR9EELow,LowR9EEHigh"
#SCALES="HighR9LowEB,HighR9HighEB,HighR9LowEE,HighR9HighEE,LowR9LowEB,LowR9HighEB,LowR9LowEE,LowR9HighEE"

SCALESCORR="MaterialCentralBarrel,MaterialOuterBarrel,MaterialForward,FNUFEE,FNUFEB,ShowerShapeHighR9EE,ShowerShapeHighR9EB,ShowerShapeLowR9EE,ShowerShapeLowR9EB"
SCALESGLOBAL="NonLinearity,Geant4"
SMEARS="HighR9EBPhi,HighR9EBRho,HighR9EEPhi,HighR9EERho,LowR9EBPhi,LowR9EBRho,LowR9EEPhi,LowR9EERho"

MASSLIST="120,125,130"
#MASSLIST="120,123,124,126,127,130"

MLOW=120
MHIGH=130
echo "Masslist is $MASSLIST"

#cd /vols/build/cms/es811/FreshStart/Pass6/CMSSW_7_4_7/src/flashggFinalFit/Signal
#eval `scramv1 runtime -sh`
#./runSignalScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --massList $MASSLIST --bs $BSWIDTH \
#                        --smears $SMEARS --scales $SCALES --scalesCorr $SCALESCORR --scalesGlobal $SCALESGLOBAL --useSSF 1 --useDCB_1G 0 --calcPhoSystOnly
./runSignalScripts.sh -i $FILE -p $PROCS -f $CATS --ext $EXT --intLumi $INTLUMI --batch $BATCH --massList $MASSLIST --bs $BSWIDTH \
                        --smears $SMEARS --scales $SCALES --scalesCorr $SCALESCORR --scalesGlobal $SCALESGLOBAL --useSSF 1 --useDCB_1G 0 



############################################################## Package Output ##########################################################
#    ls $PWD/$OUTDIR/CMS-HGG_sigfit_${EXT}_*.root > out.txt
#    echo "ls ../Signal/$OUTDIR/CMS-HGG_sigfit_${EXT}_*.root > out.txt"
#    counter=0
#    while read p ; do
#      if (($counter==0)); then
#        SIGFILES="$p"
#      else
#        SIGFILES="$SIGFILES,$p"
#      fi
#      ((counter=$counter+1))
#    done < out.txt
#    echo "SIGFILES $SIGFILES"

#    echo "./bin/PackageOutput -i $SIGFILES --procs $PROCS -l $INTLUMI -p $OUTDIR/sigfit -W wsig_13TeV -f $CATS -L 120 -H 130 -o $OUTDIR/CMS-HGG_sigfit_$EXT.root"
#    ./bin/PackageOutput -i $SIGFILES --procs $PROCS -l $INTLUMI -p $OUTDIR/sigfit -W wsig_13TeV -f $CATS -L 120 -H 130 -o $OUTDIR/CMS-HGG_sigfit_$EXT.root > package.out
########################################################################################################################################

############################################################## Final Plots Only ########################################################
echo " ./bin/makeParametricSignalModelPlots -i $OUTDIR/CMS-HGG_sigfit_$EXT.root  -o $OUTDIR -p $PROCS -f $CATS"
#./bin/makeParametricSignalModelPlots -i $OUTDIR/CMS-HGG_sigfit_$EXT.root  -o $OUTDIR/sigplots -p $PROCS -f $CATS > signumbers_${EXT}.txt

#./makeSlides.sh $OUTDIR
#mv fullslides.pdf $OUTDIR/fullslides_${EXT}.pdf
########################################################################################################################################
