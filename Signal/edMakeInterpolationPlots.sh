#!/bin/bash

#FILE="/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M120_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M123_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M124_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M126_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M127_13TeV_amcatnloFXFX_pythia8.root,/vols/cms/szenz/ws_750_30July/output_GluGluHToGG_M130_13TeV_amcatnloFXFX_pythia8.root"
FILE="/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M120_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M123_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M124_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M125_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M126_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M127_13TeV_amcatnlo_pythia8.root,/vols/cms/szenz/ws_750_30July/output_VBFHToGG_M130_13TeV_amcatnlo_pythia8.root"
echo "File is $FILE"
EXT="HggAnalysis_310716_BS036_example"
echo "Ext is $EXT"
#PROCS="ggh"
PROCS="vbf"
echo "Procs are $PROCS"
CATS="UntaggedTag_0,UntaggedTag_1,UntaggedTag_2,UntaggedTag_3,VBFTag_0,VBFTag_1,TTHHadronicTag,TTHLeptonicTag"
echo "Cats are $CATS"
OUTDIR="edInterpolationPlots"
echo "Outdir is $OUTDIR"
PLOTDIR="~/public_html/FinalFits/InterpolationTest/Pass2/"
echo "Outdir is $PLOTDIR"
INTLUMI=12.9
echo "Intlumi is $INTLUMI"
#BATCH="IC"
#echo "Batch is $BATCH"
#SPLIT="ggh,UntaggedTag_2"
SPLITONE="vbf"
SPLITTWO="VBFTag_0"
SPLIT="$SPLITONE,$SPLITTWO"
echo "Split is $SPLIT"
BSWIDTH=3.600000
echo "Bswidth is $BSWIDTH"
NBINS=320
echo "Nbins is $NBINS"

if [ ! -d $PLOTDIR ]
then 
  mkdir $PLOTDIR
fi
if [ ! -d $OUTDIR ]
then 
  mkdir $OUTDIR 
fi

#loop over the different interpolation scenarios
SCENARIOS=(A B C D) # scenario C still needs to be debugged
#SCENARIOS=(A B D)
#SCENARIOS=(C)
for CASE in ${SCENARIOS[@]}
do
  echo "CASE is $CASE"

  #set the mass list to use in interpolation
  case "$CASE" in 
    A)
      MASSLIST="120,123,124,125,126,127,130"
      SKIPMASSES="121,122,128,129"
      MLOW=120
      MHIGH=130
      echo "Masslist is $MASSLIST"
      ;;
    B)
      MASSLIST="120,125,130"
      SKIPMASSES="121,122,123,124,126,127,128,129"
      MLOW=120
      MHIGH=130
      #MASSLIST="120,125,127,130"
      echo "Masslist is $MASSLIST"
      ;;
    C)
      MASSLIST="123,125,127"
      SKIPMASSES="124,126"
      echo "Masslist is $MASSLIST"
      echo "adjusting MLOW and MHIGH"
      MLOW=123
      MHIGH=127
      ;;
    D)
      MASSLIST="120,123,125,127,130"
      SKIPMASSES="121,122,124,126,128,129"
      echo "Masslist is $MASSLIST"
      MLOW=120
      MHIGH=130
      ;;
    *)
      echo "ERROR - case needs to be a letter A-D"
      exit 1
  esac


  make

  echo "./bin/SignalFit -i $FILE -d dat/newConfig_$EXT.dat  --mhLow=$MLOW --mhHigh=$MHIGH  \
  -s dat/photonCatSyst_$EXT.dat --procs $PROCS -o $OUTDIR/CMS-HGG_mva_13TeV_sigfit${CASE}.root \
  -p $OUTDIR/sigfit$CASE -f $CATS --changeIntLumi $INTLUMI --massList $MASSLIST --skipMasses $SKIPMASSES \
  --split $SPLIT -v 0 --binnedFit 1 --nBins $NBINS --beamSpotReweigh 1 --dataBeamSpotWidth $BSWIDTH"

  ./bin/SignalFit -i $FILE -d dat/newConfig_$EXT.dat  --mhLow=$MLOW --mhHigh=$MHIGH -s dat/photonCatSyst_$EXT.dat --procs $PROCS -o $OUTDIR/CMS-HGG_mva_13TeV_sigfit$CASE.root -p $OUTDIR/sigfit$CASE -f $CATS --changeIntLumi $INTLUMI --massList $MASSLIST --split $SPLIT -v 3 --binnedFit 1 --nBins $NBINS --beamSpotReweigh 1 --dataBeamSpotWidth $BSWIDTH
  ./bin/SignalFit -i $FILE -d dat/newConfig_$EXT.dat  --mhLow=$MLOW --mhHigh=$MHIGH  \
  -s dat/photonCatSyst_$EXT.dat --procs $PROCS -o $OUTDIR/CMS-HGG_mva_13TeV_sigfit${CASE}.root \
  -p $OUTDIR/sigfit$CASE -f $CATS --changeIntLumi $INTLUMI --massList $MASSLIST --skipMasses $SKIPMASSES \
  --split $SPLIT -v 0 --binnedFit 1 --nBins $NBINS --beamSpotReweigh 1 --dataBeamSpotWidth $BSWIDTH

  rm testLC-${SPLITONE}_1*
done #end of loop over scenarios

./bin/edInterpolationPlots -i $OUTDIR/CMS-HGG_mva_13TeV_sigfit  -f $SPLITTWO -p $SPLITONE --skipMerged 1 -o $OUTDIR
mv $OUTDIR/*.p{df,ng} $PLOTDIR
