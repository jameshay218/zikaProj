datFile <- "~/Documents/Zika/Data/brazil/microceph_reports_2016.csv"
incFile <- "~/Documents/Zika/Data/brazil/brazil_report_zikv_inc_2016.csv"
microDat <- read.csv(datFile,stringsAsFactors=FALSE)
incDat <- read.csv(incFile,stringsAsFactors=FALSE)

peakTimes <- data.frame(local=c("bahia","pernambuco","riograndedonorte","pernambuco_confirmed","riograndedonorte_confirmed"),start=c(855,804,862,804,862)-30, end = c(855,804,862,804,862)+30)

maxChain <- 5
versions <- c(1,2, 3)
priors <- NULL
extra_unfixed <- NULL

combos <- expand.grid(runName = "riograndedonorte", chainNo=1:maxChain,version=versions,stringsAsFactors=FALSE)
jobs_rio <- queuer::enqueue_bulk(obj1, combos, "model_fitting_script",
                                 stateNames="riograndedonorte",microDat=microDat,
                                 incDat=incDat,preParTab=NULL,
                                 allowablePars=NULL,incStates=NULL,
                                 mcmcPars=mcmcPars,mcmcPars2=mcmcPars2,allPriors=priors,
                                 useInc=TRUE,usePeakTimes=FALSE,covMat=NULL,
                                 peakTimeRange=NULL,peakTime=NULL,sim=FALSE, predict=FALSE,
                                 microChain=NULL,prePeakTimes=peakTimes,normLik=FALSE,
                                 stateWeights=NULL,extra_unfixed=extra_unfixed,mosquito_lifespan=5,
                                 do_call=TRUE,timeout=0)


datFile <- "~/Documents/Zika/Data/brazil/microceph_reports_2016_confirmed.csv"
microDat <- read.csv(datFile,stringsAsFactors=FALSE)
combos <- expand.grid(runName = "riograndedonorte_confirmed", chainNo=1:maxChain,version=versions,stringsAsFactors=FALSE)
jobs_rio <- queuer::enqueue_bulk(obj1, combos, "model_fitting_script",
                                 stateNames="riograndedonorte",microDat=microDat,
                                 incDat=incDat,preParTab=NULL,
                                 allowablePars=NULL,incStates=NULL,
                                 mcmcPars=mcmcPars,mcmcPars2=mcmcPars2,allPriors=priors,
                                 useInc=TRUE,usePeakTimes=FALSE,covMat=NULL,
                                 peakTimeRange=NULL,peakTime=NULL,sim=FALSE, predict=FALSE,
                                 microChain=NULL,prePeakTimes=peakTimes,normLik=FALSE,
                                 stateWeights=NULL,extra_unfixed=extra_unfixed,mosquito_lifespan=5,
                                 do_call=TRUE,timeout=0)
