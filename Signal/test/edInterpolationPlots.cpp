// exectubale adapted from root Macro by M. Kenzie adapted from P. Meridiani.
// L. Corpe 07/2015
// E. Scott 10/2016
// idea is to make a loop over different sets of masslists corresponding to different interpolation scenarios
// and for each make m_mean, sigma_eff, and eff*acc plots as a function of mass 


#include <iostream>
#include <string>
#include <map>
#include <vector>

#include "TFile.h"
#include "TMath.h"
#include "TCanvas.h"
#include "TH1F.h"
#include "TLegend.h"
#include "TGraph.h"
#include "TMultiGraph.h"

#include "TStopwatch.h"
#include "RooWorkspace.h"
#include "RooDataSet.h"
#include "RooDataHist.h"
#include "RooAddPdf.h"
#include "RooGaussian.h"
#include "RooRealVar.h"
#include "RooFormulaVar.h"
#include "RooFitResult.h"
#include "RooPlot.h"
#include "RooMsgService.h"
#include "RooMinuit.h"

#include "boost/program_options.hpp"
#include "boost/algorithm/string/split.hpp"
#include "boost/algorithm/string/classification.hpp"
#include "boost/algorithm/string/predicate.hpp"

#include "TROOT.h"
#include "TStyle.h"
#include "TLatex.h"
#include "TPaveText.h"
#include "TArrow.h"

#ifndef TDRSTYLE_C
#define TDRSTYLE_C
#include "../../tdrStyle/tdrstyle.C"
#include "../../tdrStyle/CMS_lumi.C"
#endif

using namespace std;
using namespace RooFit;
using namespace boost;
namespace po = boost::program_options;

string filename_;
string outfilename_;
string datfilename_;
//int m_hyp_;
//double m_hyp_;
string procString_;
int ncats_;
int binning_;
string flashggCatsStr_;
vector<string> flashggCats_;
vector<string> procs_;
bool isFlashgg_;
bool blind_;
int sqrts_;
bool doTable_;
bool verbose_;
bool doCrossCheck_;
bool skipMerged_;
bool markNegativeBins_;

void OptionParser(int argc, char *argv[]){
  po::options_description desc1("Allowed options");
  desc1.add_options()
    ("help,h",                                                                                "Show help")
    ("infilename,i", po::value<string>(&filename_),                                           "Input file name")
    ("outfilename,o", po::value<string>(&outfilename_),                                           "Output file name")
    //("mass,m", po::value<int>(&m_hyp_)->default_value(125),                                    "Mass to run at")
    //("mass,m", po::value<double>(&m_hyp_)->default_value(125),                                    "Mass to run at")
    ("sqrts", po::value<int>(&sqrts_)->default_value(13),                                    "CoM energy")
    ("binning", po::value<int>(&binning_)->default_value(70),                                    "CoM energy")
    ("procs,p", po::value<string>(&procString_)->default_value("ggh,vbf,wh,zh,tth"),          "Processes")
    ("isFlashgg",  po::value<bool>(&isFlashgg_)->default_value(true),                          "Use flashgg format")
    ("blind",  po::value<bool>(&blind_)->default_value(true),                          "blind analysis")
    ("doTable",  po::value<bool>(&doTable_)->default_value(false),                          "doTable analysis")
    ("doCrossCheck",  po::value<bool>(&doCrossCheck_)->default_value(false),                          "output additional details")
    ("skipMerged",  po::value<bool>(&skipMerged_)->default_value(false),                          "skip the merged dataset")
    ("verbose",  po::value<bool>(&verbose_)->default_value(false),                          "output additional details")
    ("markNegativeBins",  po::value<bool>(&markNegativeBins_)->default_value(false),                          " show with red arrow if a bin has a negative total value")
    ("flashggCats,f", po::value<string>(&flashggCatsStr_)->default_value("DiPhotonUntaggedCategory_0,DiPhotonUntaggedCategory_1,DiPhotonUntaggedCategory_2,DiPhotonUntaggedCategory_3,DiPhotonUntaggedCategory_4,VBFTag_0,VBFTag_1,VBFTag_2"),       "Flashgg category names to consider")
    ;

  po::options_description desc2("Options kept for backward compatibility");
  desc2.add_options()
    ("ncats,n", po::value<int>(&ncats_)->default_value(9),                                      "Number of cats (Set Automatically if using --isFlashgg 1)")
    ;
  po::options_description desc("Allowed options");
  desc.add(desc1).add(desc2);

  po::variables_map vm;
  po::store(po::parse_command_line(argc,argv,desc),vm);
  po::notify(vm);
  if (vm.count("help")){ cout << desc << endl; exit(1);}
}

map<string,RooDataSet*> getFlashggData(RooWorkspace *work, int ncats, int m_hyp){

  map<string,RooDataSet*> result;

  for (int cat=0; cat<ncats; cat++){
    result.insert(pair<string,RooDataSet*>(Form("%s",flashggCats_[cat].c_str()),(RooDataSet*)work->data(Form("sig_mass_m%3d_%s",m_hyp,flashggCats_[cat].c_str()))));
  }
  result.insert(pair<string,RooDataSet*>("all",(RooDataSet*)work->data(Form("sig_mass_m%3d_AllCats",m_hyp))));

  return result;
}

map<string,RooDataSet*> getFlashggDataGranular(RooWorkspace *work, int ncats, int m_hyp){

  map<string,RooDataSet*> result;

  for (int cat=0; cat<ncats; cat++){
    for (int proc=0; proc < procs_.size() ; proc++){
     result.insert(pair<string,RooDataSet*>(Form("%s_%s",procs_[proc].c_str(),flashggCats_[cat].c_str()),(RooDataSet*)work->data(Form("sig_%s_mass_m%3d_%s",procs_[proc].c_str(),m_hyp,flashggCats_[cat].c_str()))));
      //assert(work->data(Form("sig_%s_mass_m%3d_%s",procs_[proc].c_str(),m_hyp,flashggCats_[cat].c_str()))); // causing error, trying to skip it... 
    }
  }

  return result;
}

map<string,RooAddPdf*> getFlashggPdfs(RooWorkspace *work, int ncats){

  map<string,RooAddPdf*> result;
  for (int cat=0; cat<ncats; cat++){
    result.insert(pair<string,RooAddPdf*>(Form("%s",flashggCats_[cat].c_str()),(RooAddPdf*)work->pdf(Form("sigpdfrel%s_allProcs",flashggCats_[cat].c_str()))));
  }
  result.insert(pair<string,RooAddPdf*>("all",(RooAddPdf*)work->pdf("sigpdfrelAllCats_allProcs")));

  return result;
}

map<string,RooAddPdf*> getFlashggPdfsGranular(RooWorkspace *work, int ncats){

  map<string,RooAddPdf*> result;
  for (int cat=0; cat<ncats; cat++){
    for (int proc=0; proc< procs_.size() ; proc++){
      result.insert(pair<string,RooAddPdf*>(Form("%s_%s",procs_[proc].c_str(),flashggCats_[cat].c_str()),(RooAddPdf*)work->pdf((Form("extendhggpdfsmrel_13TeV_%s_%sThisLumi",procs_[proc].c_str(),flashggCats_[cat].c_str())))));
      assert(work->pdf((Form("extendhggpdfsmrel_13TeV_%s_%sThisLumi",procs_[proc].c_str(),flashggCats_[cat].c_str()))));
  }
  }

  return result;
}

void printInfo(map<string,RooDataSet*> data, map<string,RooAddPdf*> pdfs){

  for (map<string,RooDataSet*>::iterator dat=data.begin(); dat!=data.end(); dat++){
    if (!dat->second) {
      cout << "dataset for " << dat->first << " not found" << endl;
      exit(1);
    }
    cout << dat->first << " : ";
    dat->second->Print();
  }
  for (map<string,RooAddPdf*>::iterator pdf=pdfs.begin(); pdf!=pdfs.end(); pdf++){
    if (!pdf->second) {
      cout << "pdf for " << pdf->first << " not found" << endl;
      exit(1);
    }
    cout << pdf->first << " : ";
    pdf->second->Print();
  }
}

pair<double,double> getEffSigmaData(RooRealVar *mass, RooDataHist *dataHist, double wmin=110., double wmax=130., double step=0.002, double epsilon=1.e-4){

  //RooAbsReal *cdf = pdf->createCdf(RooArgList(*mass));
  //RooDataHist *cumulativeHistogram = (RooDataHist*) dataHist->emptyClone();
  //cout << "Computing effSigma FOR DATA...." << endl;
  TStopwatch sw;
  sw.Start();
  double point=wmin;
  double weight=0; 
  vector<pair<double,double> > points;
  //std::cout << " dataHist " << *dataHist << std::endl;
  double thesum = dataHist->sumEntries();
  for (int i=0 ; i<dataHist->numEntries() ; i++){
    double mass = dataHist->get(i)->getRealValue("CMS_hgg_mass");
    weight += dataHist->weight(); 
    //std::cout << " mass " << mass << " cumulative weight " << weight/thesum << std::endl;
    if (weight > epsilon){
      points.push_back(pair<double,double>(mass,weight/thesum)); 
    }
  }
  //while (point <= wmax){
    //mass->setVal(point);
    //if (pdf->getVal() > epsilon){
    //  points.push_back(pair<double,double>(point,cdf->getVal())); 
    //}
    //point+=step;
  //}
  double low = wmin;
  double high = wmax;
  double width = wmax-wmin;
  for (unsigned int i=0; i<points.size(); i++){
    for (unsigned int j=i; j<points.size(); j++){
      double wy = points[j].second - points[i].second;
      if (TMath::Abs(wy-0.683) < epsilon){
        double wx = points[j].first - points[i].first;
        if (wx < width){
          low = points[i].first;
          high = points[j].first;
          width=wx;
        }
      }
    }
  }
  sw.Stop();
  //cout << "FILTER effSigma: [" << low << "-" << high << "] = " << width/2. << endl;
  //cout << "\tTook: "; sw.Print();
  pair<double,double> result(low,high);
  return result;
}

pair<double,double> getEffSigma(RooRealVar *mass, RooAbsPdf *pdf, double wmin=110., double wmax=130., double step=0.002, double epsilon=1.e-4){

  RooAbsReal *cdf = pdf->createCdf(RooArgList(*mass));
  cout << "Computing effSigma...." << endl;
  TStopwatch sw;
  sw.Start();
  double point=wmin;
  vector<pair<double,double> > points;

  while (point <= wmax){
    mass->setVal(point);
    if (pdf->getVal() > epsilon){
      points.push_back(pair<double,double>(point,cdf->getVal())); 
    }
    point+=step;
  }
  double low = wmin;
  double high = wmax;
  double width = wmax-wmin;
  for (unsigned int i=0; i<points.size(); i++){
    for (unsigned int j=i; j<points.size(); j++){
      double wy = points[j].second - points[i].second;
      if (TMath::Abs(wy-0.683) < epsilon){
        double wx = points[j].first - points[i].first;
        if (wx < width){
          low = points[i].first;
          high = points[j].first;
          width=wx;
        }
      }
    }
  }
  sw.Stop();
  cout << "effSigma: [" << low << "-" << high << "] = " << width/2. << endl;
  //cout << "\tTook: "; sw.Print();
  pair<double,double> result(low,high);
  return result;
}

// get effective sigma from finely binned histogram
pair<double,double> getEffSigBinned(RooRealVar *mass, RooAbsPdf *pdf, double wmin=110., double wmax=130.,int stepsize=1 ){

  int nbins = int((wmax-wmin)/0.001/double(stepsize));
  TH1F *h = new TH1F("h","h",nbins,wmin,wmax);
  pdf->fillHistogram(h,RooArgList(*mass));

  double narrowest=1000.;
  double bestInt;
  int lowbin;
  int highbin;

  double oneSigma=1.-TMath::Prob(1,1);

  TStopwatch sw;
  sw.Start();
  // get first guess
  cout << "Getting first guess info. stepsize (MeV) = " << stepsize*100 << endl;
  for (int i=0; i<h->GetNbinsX(); i+=(stepsize*100)){
    for (int j=i; j<h->GetNbinsX(); j+=(stepsize*100)){
      double integral = h->Integral(i,j)/h->Integral();
      if (integral<oneSigma) continue;
      double width = h->GetBinCenter(j)-h->GetBinCenter(i);
      if (width<narrowest){
        narrowest=width;
        bestInt=integral;
        lowbin=i;
        highbin=j;
        i++;
      }
    }
  }
  cout << "Took: "; sw.Print(); 
  // narrow down result
  int thisStepSize=32;
  cout << "Narrowing....." << endl;
  while (thisStepSize>stepsize) {
    cout << "\tstepsize (MeV) = " << thisStepSize << endl;
    for (int i=(lowbin-10*thisStepSize); i<(lowbin+10*thisStepSize); i+=thisStepSize){
      for (int j=(highbin-10*thisStepSize); j<(highbin+10*thisStepSize); j+=thisStepSize){
        double integral = h->Integral(i,j)/h->Integral();
        if (integral<oneSigma) continue;
        double width = h->GetBinCenter(j)-h->GetBinCenter(i);
        if (width<narrowest){
          narrowest=width;
          bestInt=integral;
          lowbin=i;
          highbin=j;
          i++;
        }
      }
    }
    thisStepSize/=2;
  }

  sw.Stop();
  cout << narrowest/2. << " " << bestInt << " [" << h->GetBinCenter(lowbin) << "," << h->GetBinCenter(highbin) << "]" << endl;
  cout << "Took:"; sw.Print();
  pair<double,double> result(h->GetBinCenter(lowbin),h->GetBinCenter(highbin));
  delete h;
  return result;
}

// get FWHHM
vector<double> getFWHM(RooRealVar *mass, RooAbsPdf *pdf, RooDataSet *data, double wmin=110., double wmax=130., double step=0.0004) {

  cout << "Computing FWHM...." << endl;
  double nbins = (wmax-wmin)/step;
  TH1F *h = new TH1F("h","h",int(floor(nbins+0.5)),wmin,wmax);
  if (data){
    pdf->fillHistogram(h,RooArgList(*mass),data->sumEntries());
  }
  else {
    pdf->fillHistogram(h,RooArgList(*mass));
  }

  double hm = h->GetMaximum()*0.5;
  double low = h->GetBinCenter(h->FindFirstBinAbove(hm));
  double high = h->GetBinCenter(h->FindLastBinAbove(hm));
  double mpeak = h->GetBinCenter( h->GetMaximumBin() );
  double mmean = h->GetMean();

  cout << "FWHM: [" << low << "-" << high << "] Max = " << hm << endl;
  vector<double> result;
  result.push_back(low);
  result.push_back(high);
  result.push_back(hm);
  result.push_back(h->GetBinWidth(1));
  result.push_back(mpeak);
  result.push_back(mmean);

  delete h;
  return result;
}

void Plot(RooRealVar *mass, RooDataSet *data, RooAbsPdf *pdf, pair<double,double> sigRange, vector<double> fwhmRange, string title, string savename){

  double semin=sigRange.first;
  double semax=sigRange.second;
  double fwmin=fwhmRange[0];
  double fwmax=fwhmRange[1];
  double halfmax=fwhmRange[2];
  double binwidth=fwhmRange[3];
  double mpeak=fwhmRange[4];
  double mmean=fwhmRange[5];
  //double mpeak=125.09;
  //double mnom=m_hyp_;
  double mnom=9999.;
  vector<double> negWeightBins;
  vector<double> negWeightBinsValues;
  RooPlot *plot = mass->frame(Bins(binning_),Range("higgsRange"));
  plot->SetMinimum(0.0);
  if (markNegativeBins_){
  TH1F *rdh = (TH1F*) data->createHistogram("CMS_hgg_mass",*mass,Binning(binning_,105,140));
    for(unsigned int iBin =0 ; iBin < rdh->GetNbinsX() ; iBin++){
      float content = rdh->GetBinContent(iBin);
      float center = rdh->GetBinCenter(iBin);
      if(content <0) {
        std::cout <<" BIN "<< iBin << " has negative weight : " << content << " at " << center << std::endl;
        negWeightBins.push_back(center);
        negWeightBinsValues.push_back(content);
      }
    }
  }
  double offset =0.05;
  if (data) data->plotOn(plot,Invisible());
  pdf->plotOn(plot,NormRange("higgsRange"),Range(semin,semax),FillColor(19),DrawOption("F"),LineWidth(2),FillStyle(1001),VLines(),LineColor(15));
  TObject *seffLeg = plot->getObject(int(plot->numItems()-1));
  pdf->plotOn(plot,NormRange("higgsRange"),Range(semin,semax),LineColor(15),LineWidth(2),FillStyle(1001),VLines());
  pdf->plotOn(plot,NormRange("higgsRange"),Range("higgsRange"),LineColor(kBlue),LineWidth(2),FillStyle(0));
  TObject *pdfLeg = plot->getObject(int(plot->numItems()-1));
  if (data) data->plotOn(plot,MarkerStyle(kOpenSquare));
  TObject *dataLeg = plot->getObject(int(plot->numItems()-1));
  //TLegend *leg = new TLegend(0.15,0.89,0.5,0.55);
  TLegend *leg = new TLegend(0.15+offset,0.40,0.5+offset,0.82);
  leg->SetFillStyle(0);
  leg->SetLineColor(0);
  leg->SetTextSize(0.037);
  if (data) leg->AddEntry(dataLeg,"#bf{Simulation}","lep");
  leg->AddEntry(pdfLeg,"#splitline{#bf{Parametric}}{#bf{model}}","l");
  leg->AddEntry(seffLeg,Form("#bf{#sigma_{eff} = %1.2f GeV}",0.5*(semax-semin)),"fl");
  plot->GetXaxis()->SetNdivisions(509);
  halfmax*=(plot->getFitRangeBinW()/binwidth);
  TArrow *fwhmArrow = new TArrow(fwmin,halfmax,fwmax,halfmax,0.02,"<>");
  fwhmArrow->SetLineWidth(2.);
  TPaveText *fwhmText = new TPaveText(0.17+offset,0.22,0.45+offset,0.37,"brNDC");
  fwhmText->SetFillColor(0);
  fwhmText->SetLineColor(kWhite);
  fwhmText->SetTextSize(0.037);
  //fwhmText->AddText(Form("FWHM = %1.2f GeV",(fwmax-fwmin)));
  fwhmText->AddText(Form("m_{peak}= %1.4f GeV",(mpeak)));
  fwhmText->AddText(Form("m_{mean}= %1.4f GeV",(mmean)));
  fwhmText->AddText(Form("m_{nom.}= %1.4f GeV",(mnom)));
  std::cout << " [FOR TABLE] Tag " << data->GetName() << "=, Mass " << mass->getVal() << " sigmaEff=" << 0.5*(semax-semin) << "= , FWMH=" << (fwmax-fwmin)/2.35 << "=" << std::endl;
  //std::cout << " [RESOLUTION CHECK] Ta/Procg " << data->GetName() << ", Mass " << mass->getVal() << " sigmaEff=" << 0.5*(semax-semin) << " , FWMH=" << (fwmax-fwmin)/2.35 << "" << std::endl;

  //TLatex lat1(0.65,0.85,"#splitline{CMS Simulation}{}");
  TLatex  lat1(.129+0.03+offset,0.85,"H#rightarrow#gamma#gamma");
  lat1.SetNDC(1);
  lat1.SetTextSize(0.047);

  TString catLabel_humanReadable  = title;
  catLabel_humanReadable.ReplaceAll("_"," ");
  catLabel_humanReadable.ReplaceAll("UntaggedTag","Untagged");
  catLabel_humanReadable.ReplaceAll("VBFTag","VBF Tag");
  catLabel_humanReadable.ReplaceAll("TTHLeptonicTag","TTH Leptonic Tag");
  catLabel_humanReadable.ReplaceAll("TTHHadronicTag","TTH Hadronic Tag");
  catLabel_humanReadable.ReplaceAll("all","All Categories");

  TLatex lat2(0.93,0.88,catLabel_humanReadable);
  lat2.SetTextAlign(33);
  lat2.SetNDC(1);
  lat2.SetTextSize(0.045);

  TCanvas *canv = new TCanvas("canv","canv",650,600);
  canv->SetLeftMargin(0.16);
  canv->SetTickx(); canv->SetTicky();
  plot->SetTitle("");
  plot->GetXaxis()->SetTitle("m_{#gamma#gamma} (GeV)");
  plot->GetXaxis()->SetTitleSize(0.05);
  plot->GetYaxis()->SetTitleSize(0.05);
  plot->GetYaxis()->SetTitleOffset(1.5);
  plot->SetMinimum(0.0);
  plot->Draw();
  fwhmArrow->Draw("same <>");
  fwhmText->Draw("same");
   //lat1.Draw("same");
  lat2.Draw("same");
  lat1.Draw("same");
  leg->Draw("same");
  for (unsigned int i =0 ; i < negWeightBins.size() ; i++){
  TArrow *negBinsArrow = new TArrow(negWeightBins[i],0.0,negWeightBins[i],halfmax/2,0.02,"<>");
  negBinsArrow->SetLineWidth(2.);
  negBinsArrow->SetLineColor(kRed);
  negBinsArrow->Draw("same <>");

  }
  string sim="Simulation Preliminary";
  CMS_lumi( canv, 0,0,sim);
  canv->Print(Form("%s.pdf",savename.c_str()));
  canv->Print(Form("%s.png",savename.c_str()));
  //string path = savename.substr(0,savename.find('/'));
  //canv->Print(Form("%s/animation.gif+100",path.c_str()));

  delete canv;

}

int main(int argc, char *argv[]){

  OptionParser(argc,argv);
  TStopwatch sw;
  sw.Start();
  RooMsgService::instance().setGlobalKillBelow(RooFit::ERROR);
  RooMsgService::instance().setSilentMode(true);
  system("mkdir -p plots/SignalPlots/");
  setTDRStyle();
  writeExtraText = true;       // if extra text
  extraText  = "";  // default extra text is "Preliminary"
  lumi_13TeV  = "2.7 fb^{-1}"; // default is "19.7 fb^{-1}"
  lumi_8TeV  = "19.1 fb^{-1}"; // default is "19.7 fb^{-1}"
  lumi_7TeV  = "4.9 fb^{-1}";  // default is "5.1 fb^{-1}"
  lumi_sqrtS = "13 TeV";       // used with iPeriod = 0, e.g. for simulation-only plots (default is an empty string)

  split(procs_,procString_,boost::is_any_of(","));
  split(flashggCats_,flashggCatsStr_,boost::is_any_of(","));
  if (isFlashgg_){
    ncats_ =flashggCats_.size();
    // Ensure that the loop over the categories does not go out of scope. 
    std::cout << "[INFO] consider "<< ncats_ <<" tags/categories" << std::endl;
  }


  gROOT->SetBatch();
  gStyle->SetTextFont(42);


  // want to change this to loop over scenario file names instead 
  vector<string> scenarios;
  scenarios.push_back( "A" );
  scenarios.push_back( "B" );
  scenarios.push_back( "C" );
  scenarios.push_back( "D" );
  vector<TH1*> vecSigmaEffHists;
  vector<TH1*> vecDeltaMHists;
  vector<TH1*> vecEffStarAccHists;

  const int numMasses = 40;
  const float massLow  = 123.;
  const float deltaM = 0.1;
  const float massHigh = massLow + deltaM*numMasses;
  for( uint scenIndex=0; scenIndex<scenarios.size(); scenIndex++ )
  {
    string scenario = scenarios[scenIndex];
    string hName = "hEffSigma" + scenario;
    vecSigmaEffHists.push_back( new TH1F( hName.c_str(), "sigma_eff as a function of mH", numMasses+1, massLow - deltaM/2., massHigh + deltaM/2 ) );
    hName = "hDeltaM" + scenario;
    vecDeltaMHists.push_back( new TH1F( hName.c_str(), "mean mass a function of mH", numMasses+1, massLow - deltaM/2., massHigh + deltaM/2 ) );
    hName = "hEffStarAcc" + scenario;
    vecEffStarAccHists.push_back( new TH1F( hName.c_str(), "eff*acc as a function of mH", numMasses+1, massLow - deltaM/2., massHigh + deltaM/2 ) );
  }
  for( uint scenIndex=0; scenIndex<scenarios.size(); scenIndex++ )
  {
    string scenario = scenarios[scenIndex];
    string scenFileName = filename_ + scenario + ".root";
    //TFile *hggFile = TFile::Open(filename_.c_str());
    TFile *hggFile = TFile::Open(scenFileName.c_str());
    RooWorkspace *hggWS;
    hggWS = (RooWorkspace*)hggFile->Get(Form("wsig_%dTeV",sqrts_));

    if (!hggWS) {
      cerr << "Workspace is null" << endl;
      exit(1);
    }

    RooRealVar *mass= (RooRealVar*)hggWS->var("CMS_hgg_mass");

    RooRealVar *mh = (RooRealVar*)hggWS->var("MH");

    // now loop over considered mass values
    for( uint massIndex=0; massIndex<=numMasses; massIndex++ )
    {
      double loopMass = massLow + deltaM*massIndex;
      mh->setVal(loopMass);
      mass->setRange("higgsRange",loopMass-20.,loopMass+15.);

      map<string,RooDataSet*> dataSets;
      map<string,RooDataSet*> dataSetsGranular;
      map<string,RooAddPdf*> pdfs;
      map<string,RooAddPdf*> pdfsGranular;

      if (isFlashgg_){
	dataSets = getFlashggData(hggWS,ncats_,loopMass);
	dataSetsGranular = getFlashggDataGranular(hggWS,ncats_,loopMass);
	pdfs = getFlashggPdfs(hggWS,ncats_);
	pdfsGranular = getFlashggPdfsGranular(hggWS,ncats_);
      }

      //  printInfo(dataSets,pdfs);


      system(Form("mkdir -p %s",outfilename_.c_str()));
      system(Form("rm -f %s/animation.gif",outfilename_.c_str()));


      for (map<string,RooDataSet*>::iterator dataIt=dataSetsGranular.begin(); dataIt!=dataSetsGranular.end(); dataIt++)
      {
	pair<double,double> thisSigRange = getEffSigma(mass,pdfsGranular[dataIt->first],loopMass-10.,loopMass+10.);
        float sigmaEff = 0.5 * ( thisSigRange.second - thisSigRange.first );
        vecSigmaEffHists[scenIndex]->Fill( loopMass, sigmaEff );
	vector<double> thisFWHMRange = getFWHM(mass,pdfsGranular[dataIt->first],dataIt->second,loopMass-10.,loopMass+10.);
        float meanMass = thisFWHMRange[5];
        vecDeltaMHists[scenIndex]->Fill( loopMass, meanMass - loopMass );
      }

    } // end of loop over masses
    hggFile->Close();
  } // end of loop over scenarios

  //TFile *tempOutFile = new TFile( "outputTemp.root", "recreate" );
  //tempOutFile->cd();
  //for( uint i=0; i<vecSigmaEffHists.size(); i++ ) vecSigmaEffHists[i]->Write();
  //for( uint i=0; i<vecDeltaMHists.size(); i++ ) vecDeltaMHists[i]->Write();
  //tempOutFile->Close();

  // draw and save hists
  TCanvas *c = new TCanvas("c","c",600,500);
  c->cd();
  vecSigmaEffHists[0]->SetLineColor(kGreen);
  vecSigmaEffHists[0]->SetMarkerColor(kGreen);
  vecSigmaEffHists[0]->SetMarkerStyle(kPlus);
  vecSigmaEffHists[0]->SetTitle("#sigma_{eff} vs m_{H}");
  vecSigmaEffHists[0]->GetXaxis()->SetTitle("m_{H}");
  vecSigmaEffHists[0]->GetXaxis()->SetLabelSize(0.03);
  vecSigmaEffHists[0]->GetYaxis()->SetTitle("#sigma_{eff}");
  vecSigmaEffHists[0]->GetYaxis()->SetLabelSize(0.03);
  vecSigmaEffHists[0]->Draw("hist,C");
  //vecSigmaEffHists[0]->Draw("hist");
  vecSigmaEffHists[1]->SetLineColor(kRed);
  vecSigmaEffHists[1]->SetMarkerColor(kRed);
  vecSigmaEffHists[1]->SetMarkerStyle(kPlus);
  vecSigmaEffHists[1]->Draw("hist,same,C");
  //vecSigmaEffHists[1]->Draw("hist,same");
  vecSigmaEffHists[2]->SetLineColor(kBlue);
  vecSigmaEffHists[2]->SetMarkerColor(kBlue);
  vecSigmaEffHists[2]->SetMarkerStyle(kPlus);
  vecSigmaEffHists[2]->Draw("hist,same,C");
  //vecSigmaEffHists[2]->Draw("hist,same");
  vecSigmaEffHists[3]->SetLineColor(kBlack);
  vecSigmaEffHists[3]->SetMarkerColor(kBlack);
  vecSigmaEffHists[3]->Draw("hist,same,C");
  //vecSigmaEffHists[3]->Draw("hist,same");
  TLegend* l = new TLegend(0.7,0.16,0.9,0.36);
  l->SetBorderSize(0);
  l->AddEntry( vecSigmaEffHists[0], "Scenario A", "l" );
  l->AddEntry( vecSigmaEffHists[1], "Scenario B", "l" );
  l->AddEntry( vecSigmaEffHists[2], "Scenario C", "l" );
  l->AddEntry( vecSigmaEffHists[3], "Scenario D", "l" );
  l->Draw();
  string outputPlotName = outfilename_ + "/hSigmaEff.pdf";
  c->Print( outputPlotName.c_str() );
  outputPlotName = outfilename_ + "/hSigmaEff.png";
  c->Print( outputPlotName.c_str() );
  delete l;
  vecDeltaMHists[0]->SetLineColor(kGreen);
  vecDeltaMHists[0]->SetMarkerColor(kGreen);
  vecDeltaMHists[0]->SetMarkerStyle(kPlus);
  vecDeltaMHists[0]->SetTitle("#bar{m_{H}} vs m_{H}");
  vecDeltaMHists[0]->GetXaxis()->SetTitle("m_{H}");
  vecDeltaMHists[0]->GetXaxis()->SetLabelSize(0.03);
  vecDeltaMHists[0]->GetYaxis()->SetTitle("#bar{m_{H}} - m_{H}");
  vecDeltaMHists[0]->GetYaxis()->SetLabelSize(0.03);
  vecDeltaMHists[0]->GetYaxis()->SetTitleSize(0.05);
  vecDeltaMHists[0]->GetYaxis()->SetTitleOffset(1.25);
  vecDeltaMHists[0]->Draw("hist,C");
  //vecDeltaMHists[0]->Draw("hist");
  vecDeltaMHists[1]->SetLineColor(kRed);
  vecDeltaMHists[1]->SetMarkerColor(kRed);
  vecDeltaMHists[1]->SetMarkerStyle(kPlus);
  vecDeltaMHists[1]->Draw("hist,same,C");
  //vecDeltaMHists[1]->Draw("hist,same");
  vecDeltaMHists[2]->SetLineColor(kBlue);
  vecDeltaMHists[2]->SetMarkerColor(kBlue);
  vecDeltaMHists[2]->SetMarkerStyle(kPlus);
  vecDeltaMHists[2]->Draw("hist,same,C");
  //vecDeltaMHists[2]->Draw("hist,same");
  vecDeltaMHists[3]->SetLineColor(kBlack);
  vecDeltaMHists[3]->SetMarkerColor(kBlack);
  vecDeltaMHists[3]->SetMarkerStyle(kPlus);
  vecDeltaMHists[3]->Draw("hist,same,C");
  //vecDeltaMHists[3]->Draw("hist,same");
  TLegend* ll = new TLegend(0.7,0.7,0.9,0.9);
  ll->SetBorderSize(0);
  ll->AddEntry( vecDeltaMHists[0], "Scenario A", "l" );
  ll->AddEntry( vecDeltaMHists[1], "Scenario B", "l" );
  ll->AddEntry( vecSigmaEffHists[2], "Scenario C", "l" );
  ll->AddEntry( vecSigmaEffHists[3], "Scenario D", "l" );
  ll->Draw();
  outputPlotName = outfilename_ + "/hDeltaM.pdf";
  c->Print( outputPlotName.c_str() );
  outputPlotName = outfilename_ + "/hDeltaM.png";
  c->Print( outputPlotName.c_str() );
  delete ll;

  // get, draw and save the eff*acc graphs
  TMultiGraph *fullEffAccGraph = new TMultiGraph();
  TFile *fileA = new TFile("edInterpolationPlots/sigfitA/effAccCheck_vbf_VBFTag_0.root");
  TGraph* effAccA = (TGraph*)fileA->Get("effAccGraph");
  effAccA->SetName("effAccGraphA");
  fileA->Close();
  delete fileA;
  TFile *fileB = new TFile("edInterpolationPlots/sigfitB/effAccCheck_vbf_VBFTag_0.root");
  TGraph* effAccB = (TGraph*)fileB->Get("effAccGraph");
  effAccB->SetName("effAccGraphB");
  fileB->Close();
  delete fileB;
  TFile *fileC = new TFile("edInterpolationPlots/sigfitC/effAccCheck_vbf_VBFTag_0.root");
  TGraph* effAccC = (TGraph*)fileC->Get("effAccGraph");
  effAccC->SetName("effAccGraphC");
  fileC->Close();
  delete fileC;
  TFile *fileD = new TFile("edInterpolationPlots/sigfitD/effAccCheck_vbf_VBFTag_0.root");
  TGraph* effAccD = (TGraph*)fileD->Get("effAccGraph");
  effAccD->SetName("effAccGraphD");
  fileD->Close();
  delete fileD;
  effAccA->SetLineColor(kGreen);
  effAccA->SetLineWidth(1);
  effAccA->SetMarkerColor(kGreen);
  effAccA->SetMarkerStyle(kPlus);
  effAccB->SetLineColor(kRed);
  effAccB->SetLineWidth(1);
  effAccB->SetMarkerColor(kRed);
  effAccB->SetMarkerStyle(kPlus);
  effAccC->SetLineColor(kBlue);
  effAccC->SetLineWidth(1);
  effAccC->SetMarkerColor(kBlue);
  effAccC->SetMarkerStyle(kPlus);
  effAccD->SetLineColor(kBlack);
  effAccD->SetLineWidth(1);
  effAccD->SetMarkerColor(kBlack);
  effAccD->SetMarkerStyle(kPlus);
  fullEffAccGraph->Add(effAccA); 
  fullEffAccGraph->Add(effAccB); 
  fullEffAccGraph->Add(effAccC); 
  fullEffAccGraph->Add(effAccD); 
  fullEffAccGraph->Draw("AC"); 
  //fullEffAccGraph->Draw("AP"); 
  fullEffAccGraph->SetTitle("eff #times acc vs m_{H}");
  fullEffAccGraph->GetXaxis()->SetTitle("m_{H}");
  fullEffAccGraph->GetXaxis()->SetLabelSize(0.03);
  fullEffAccGraph->GetYaxis()->SetTitle("eff #times acc");
  fullEffAccGraph->GetYaxis()->SetLabelSize(0.03);
  fullEffAccGraph->GetYaxis()->SetTitleOffset(1.5);
  TLegend* lll = new TLegend(0.2,0.7,0.4,0.9);
  lll->SetBorderSize(0);
  lll->AddEntry( effAccA, "Scenario A", "l" );
  lll->AddEntry( effAccB, "Scenario B", "l" );
  lll->AddEntry( effAccC, "Scenario C", "l" );
  lll->AddEntry( effAccD, "Scenario D", "l" );
  lll->Draw();
  outputPlotName = outfilename_ + "/gEffAcc.pdf";
  c->Print( outputPlotName.c_str() );
  outputPlotName = outfilename_ + "/gEffAcc.png";
  c->Print( outputPlotName.c_str() );
  delete lll;
}

