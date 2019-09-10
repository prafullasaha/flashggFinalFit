#!/bin/bash
sleep $[ ( $RANDOM % 10 )  + 1 ]s
touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/sigfit/SignalFitJobs/sub1.sh.run
cd /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal
eval `scramv1 runtime -sh`
number=$RANDOM
mkdir -p scratch_$number
cd scratch_$number
	 echo "PREPARING TO RUN "
if ( /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/bin/SignalFit --verbose 0 -i /afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root -d /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/dat/newConfig_Initial_tHq.dat  --mhLow=120 --mhHigh=130 -s /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/dat/photonCatSyst_Initial_tHq.dat --procs TTH,THQ -o  /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/CMS-HGG_sigfit_Initial_tHq_TTH_TTHLeptonicTag_1.root -p /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/sigfit -f TTHLeptonicTag_0,TTHLeptonicTag_1,THQLeptonicTag --changeIntLumi 41.5 --binnedFit 1 --nBins 320 --split TTH,TTHLeptonicTag_1 --beamSpotReweigh 1 --dataBeamSpotWidth 3.400000 --massList 120,125,130 --useDCBplusGaus 0 --useSSF 1 -C -1 ) then
	 echo "DONE" 
	 touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/sigfit/SignalFitJobs/sub1.sh.done
else
	 echo "FAIL" 
	 touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/sigfit/SignalFitJobs/sub1.sh.fail
fi
cd -
	 echo "RM RUN "
rm -f /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/sigfit/SignalFitJobs/sub1.sh.run
rm -rf scratch_$number
