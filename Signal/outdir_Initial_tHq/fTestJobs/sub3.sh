#!/bin/bash
touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/fTestJobs/sub3.sh.run
cd /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal
eval `scramv1 runtime -sh`
cd -
number=$RANDOM
mkdir -p scratch_$number
cd scratch_$number
if ( /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/bin/signalFTest -i /afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M120_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M125_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_thq/output_THQ_ctcvcp_HToGG_M130_13TeV-madgraph-pythia8_TuneCP5.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M120_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M125_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root,/afs/cern.ch/work/p/prsaha/public/flashgg_slc7/CMSSW_9_4_9/src/flashgg/Systematics/test/result/result_tthjet/output_ttHJetToGG_M130_13TeV_amcatnloFXFX_madspin_pythia8_TTH.root  -p TTH -f TTHLeptonicTag_0,TTHLeptonicTag_1,TTHLeptonicTag_2,THQLeptonicTag --considerOnly THQLeptonicTag -o /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq --datfilename /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/fTestJobs/outputs/config_4.dat ) then
	 touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/fTestJobs/sub3.sh.done
else
	 touch /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/fTestJobs/sub3.sh.fail
fi
rm -f /afs/cern.ch/work/p/prsaha/public/flashgg_FinalFit/CMSSW_8_1_0/src/flashggFinalFit/Signal/outdir_Initial_tHq/fTestJobs/sub3.sh.run
rm -rf scratch_$number
