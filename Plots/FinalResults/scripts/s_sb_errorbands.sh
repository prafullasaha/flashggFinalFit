#!/bin/bash

# Usage of this scipt
#./s_sb_errorbands.sh <index> <working directory> <MHhat> <Muhat>
# your input rool file must be called inputfile.root
nToys=1
MHhat=$3
Muhat=$4
dir=$2 
((startIndex=$1*10000))
index=$startIndex

cd $dir
eval `scramv1 runtime -sh`

while (( $index < $startIndex+ $nToys)); 
do
#echo "combine inputfile.root  -m $MHhat --snapshotName MultiDimFit -M GenerateOnly --saveWorkspace --toysFrequentist --bypassFrequentistFit -t 1 --expectSignal=$Muhat -n combout_step0_$index --saveToys"
#combine inputfile.root  -m $MHhat --snapshotName MultiDimFit -M GenerateOnly --saveWorkspace --toysFrequentist --bypassFrequentistFit -t 1 --expectSignal=$Muhat -n combout_step0_$index --saveToys
#
#mv higgsCombinecombout_step0_${index}.GenerateOnly*.root higgsCombinecombout_step0_done_$index.root

echo "combine inputfile.root --toysFile higgsCombinecombout_step0_done_$index.root -m $MHhat -M MultiDimFit --floatOtherPOIs=1 --saveWorkspace -t 1 -n combout_step1_$index"
#combine inputfile.root --toysFile higgsCombinecombout_step0_done_$index.root -m $MHhat -M MultiDimFit -P r --floatOtherPOIs=1 --saveWorkspace -t 1 -n combout_step1_$index
combine inputfile.root --toysFile higgsCombinecombout_step0_done_$index.root -m $MHhat -M MultiDimFit -P r --floatOtherPOIs=1 --saveWorkspace -t 1 -n combout_step1_$index --freezeParameters pdfindex_RECO_0J_Tag0_13TeV_2016,pdfindex_RECO_0J_Tag0_13TeV_2016,pdfindex_RECO_0J_Tag1_13TeV_2016,pdfindex_RECO_0J_Tag2_13TeV_2016,pdfindex_RECO_1J_PTH_0_60_Tag0_13TeV_2016,pdfindex_RECO_1J_PTH_0_60_Tag1_13TeV_2016,pdfindex_RECO_1J_PTH_60_120_Tag0_13TeV_2016,pdfindex_RECO_1J_PTH_60_120_Tag1_13TeV_2016,pdfindex_RECO_1J_PTH_120_200_Tag0_13TeV_2016,pdfindex_RECO_1J_PTH_120_200_Tag1_13TeV_2016,pdfindex_RECO_1J_PTH_GT200_13TeV_2016,pdfindex_RECO_GE2J_PTH_0_60_Tag0_13TeV_2016,pdfindex_RECO_GE2J_PTH_0_60_Tag1_13TeV_2016,pdfindex_RECO_GE2J_PTH_60_120_Tag0_13TeV_2016,pdfindex_RECO_GE2J_PTH_60_120_Tag1_13TeV_2016,pdfindex_RECO_GE2J_PTH_120_200_Tag0_13TeV_2016,pdfindex_RECO_GE2J_PTH_120_200_Tag1_13TeV_2016,pdfindex_RECO_GE2J_PTH_GT200_Tag0_13TeV_2016,pdfindex_RECO_GE2J_PTH_GT200_Tag1_13TeV_2016,pdfindex_RECO_VBFTOPO_JET3VETO_Tag0_13TeV_2016,pdfindex_RECO_VBFTOPO_JET3VETO_Tag1_13TeV_2016,pdfindex_RECO_VBFTOPO_JET3_Tag0_13TeV_2016,pdfindex_RECO_VBFTOPO_JET3_Tag1_13TeV_2016,pdfindex_RECO_VBFTOPO_REST_13TeV_2016,pdfindex_RECO_VBFTOPO_BSM_13TeV_2016,pdfindex_RECO_0J_Tag0_13TeV_2017,pdfindex_RECO_0J_Tag1_13TeV_2017,pdfindex_RECO_0J_Tag2_13TeV_2017,pdfindex_RECO_1J_PTH_0_60_Tag0_13TeV_2017,pdfindex_RECO_1J_PTH_0_60_Tag1_13TeV_2017,pdfindex_RECO_1J_PTH_60_120_Tag0_13TeV_2017,pdfindex_RECO_1J_PTH_60_120_Tag1_13TeV_2017,pdfindex_RECO_1J_PTH_120_200_Tag0_13TeV_2017,pdfindex_RECO_1J_PTH_120_200_Tag1_13TeV_2017,pdfindex_RECO_1J_PTH_GT200_13TeV_2017,pdfindex_RECO_GE2J_PTH_0_60_Tag0_13TeV_2017,pdfindex_RECO_GE2J_PTH_0_60_Tag1_13TeV_2017,pdfindex_RECO_GE2J_PTH_60_120_Tag0_13TeV_2017,pdfindex_RECO_GE2J_PTH_60_120_Tag1_13TeV_2017,pdfindex_RECO_GE2J_PTH_120_200_Tag0_13TeV_2017,pdfindex_RECO_GE2J_PTH_120_200_Tag1_13TeV_2017,pdfindex_RECO_GE2J_PTH_GT200_Tag0_13TeV_2017,pdfindex_RECO_GE2J_PTH_GT200_Tag1_13TeV_2017,pdfindex_RECO_VBFTOPO_JET3VETO_Tag0_13TeV_2017,pdfindex_RECO_VBFTOPO_JET3VETO_Tag1_13TeV_2017,pdfindex_RECO_VBFTOPO_JET3_Tag0_13TeV_2017,pdfindex_RECO_VBFTOPO_JET3_Tag1_13TeV_2017,pdfindex_RECO_VBFTOPO_REST_13TeV_2017,pdfindex_RECO_VBFTOPO_BSM_13TeV_2017

mv higgsCombinecombout_step1_${index}.MultiDimFit*.root higgsCombinecombout_step1_done_$index.root

echo "combine higgsCombinecombout_step1_done_$index.root -m $MHhat --snapshotName MultiDimFit -M GenerateOnly --saveToys --toysFrequentist --bypassFrequentistFit -t -1 -n combout_step2_$index --expectSignal=0"
combine higgsCombinecombout_step1_done_$index.root -m $MHhat --snapshotName MultiDimFit -M GenerateOnly --saveToys --toysFrequentist --bypassFrequentistFit -t -1 -n combout_step2_$index --expectSignal=0

mv higgsCombinecombout_step2_${index}.GenerateOnly*.root higgsCombinecombout_step2_done_$index.root

(( index=$index+1))
done;
