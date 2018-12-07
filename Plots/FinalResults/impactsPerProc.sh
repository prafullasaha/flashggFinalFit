#datacard=CMS-HGG_mva_13TeV_datacard.root
#datacard=CMS-HGG_mva_13TeV_datacard_PPCC_pMH_qqHPerProcessChannelCompatibility.root
datacard=CMS-HGG_mva_13TeV_datacard_PTCC_pMH_ttHOnly_constrainTHUPerProcessMu.root
proc=ttH

dirname=r_${proc}_impacts
mkdir $dirname 
cp $datacard $dirname/.
cd $dirname
echo "===============step 1========"
echo "combineTool.py -M Impacts -d $datacard -m 125 --doInitialFit --robustFit 1 -t -1 --expectSignal 1 --floatOtherPOIs=1 -P r_${proc} --minimizerAlgoForMinos Minuit2,Migrad  "
echo "============================="
combineTool.py -M Impacts -d $datacard -m 125 --doInitialFit --robustFit 1 -t -1 --expectSignal 1  --floatOtherPOIs=1 -P r_${proc}  --minimizerAlgoForMinos Minuit2,Migrad  
echo "===============step 2========"
echo "combineTool.py -M Impacts -d $datacard -m 125 --robustFit 1 -t -1 --expectSignal 1 --redefineSignalPOIs r_${proc} --doFits --job-mode SGE --task-name final_${proc} --sub-opts='-q hep.q -l h_rt=0:59:0'  --minimizerAlgoForMinos Minuit2,Migrad"
echo "============================="
combineTool.py -M Impacts -d $datacard -m 125 --robustFit 1 -t -1 --expectSignal 1 --redefineSignalPOIs r_${proc} --doFits --job-mode SGE --task-name final_${proc} --sub-opts='-q hep.q -l h_rt=0:59:0'  --minimizerAlgoForMinos Minuit2,Migrad 
RUN=1
while (( $RUN > 0 )) ; do
  RUN=`qstat |wc -l`
  echo "Running $RUN jobs"
  sleep 30
done
echo "===============step 3========"
echo "combineTool.py -M Impacts -d $datacard --redefineSignalPOIs r_${proc}  -m 125 -o impacts_${proc}.json"
echo "============================="
combineTool.py -M Impacts -d $datacard --redefineSignalPOIs r_${proc}  -m 125 -o impacts_${proc}.json
echo "===============step 4========"
echo "plotImpacts.py -i impacts_${proc}.json -o impacts_${proc}"
echo "============================="
plotImpacts.py -i impacts_${proc}.json -o impacts_${proc}
cd -
cp $dirname/impacts_${proc}.pdf .
