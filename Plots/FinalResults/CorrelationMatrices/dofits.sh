#setup fit

#STAGE="Inclusive"
#CARD="CMS-HGG_mva_13TeV_datacardMuScan.root"
#POI="r"

STAGE="Stage0"
#CARD="CMS-HGG_mva_13TeV_datacard_S0_ggHPerProcessMu.root"
CARD="higgsCombine_stage0bestFit.MultiDimFit.mH125.root"
POI="r_ggH"

#STAGE="Stage1"
#CARD="CMS-HGG_mva_13TeV_datacard_S1_ggH_0JPerProcessMu.root"
#CARD="higgsCombine_stage1bestFit.MultiDimFit.mH125.root"
#POI="r_ggH_0J"

#STAGE="Stage1Minimal"
#CARD="CMS-HGG_mva_13TeV_datacard_S1min_ggH_0JPerProcessMu.root"
#CARD="higgsCombine_stage1MinBestFit.MultiDimFit.mH125.root"
#POI="r_ggH_0J"

#copy the latest datacard
cp ../../${CARD} ${STAGE}.root

#robust hesse fit - expected
#combine -M MultiDimFit -m 125 -d ${STAGE}.root --floatOtherPOIs 1  -n _robustHesseExpected -t -1 --expectSignal 1 --freezeParameters QCDscale_qqH,QCDscale_ttH,QCDscale_VH,pdf_Higgs_qqbar,pdf_Higgs_ttH,pdf_Higgs_gg,CMS_hgg_THU_ggH_Res,CMS_hgg_THU_ggH_Mu --saveSpecifiedNuis all --saveInactivePOI 1 -P ${POI} --robustHesse 1 --robustHesseSave 1 --saveFitResult

#observed
combine -M MultiDimFit -m 125 -d ${STAGE}.root --floatOtherPOIs 1  -n _robustHesseObserved --freezeParameters QCDscale_qqH,pdf_Higgs_qqH,pdf_Higgs_ggH --saveSpecifiedNuis all --saveInactivePOI 1 -P ${POI} --robustHesse 1 --robustHesseSave 1 --saveFitResult --snapshotName MultiDimFit
