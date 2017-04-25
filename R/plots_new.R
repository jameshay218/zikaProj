create_f <- function(parTab,data,PRIOR_FUNC,incDat,perCap,...){
  microDat <- data
  incDat <- incDat

  startDays <- microDat$startDay
  endDays <- microDat$endDay
  buckets <- microDat$buckets
  births <- microDat$births
  microCeph <- microDat$microCeph
  
  zikv <- incDat$inc
  nh <- incDat$N_H
  inc_buckets <- incDat$buckets
  inc_start <- incDat$startDay
  inc_end <- incDat$endDay
  
  names_pars <- parTab$names
  f <- function(values){
      names(values) <- names_pars
      y <- model_forecast(values, startDays, endDays,
                          buckets, microCeph, births,
                          zikv, nh, inc_buckets,
                          inc_start, inc_end,perCap,...)
      return(y)
  }
}

model_forecast <- function(pars, startDays, endDays,
                           buckets, microCeph, births,
                           zikv, nh, inc_buckets,
                           inc_start, inc_end,
                           valid_days_micro, valid_days_inc,
                           perCap=FALSE){
    ## Generate microcephaly curve for these parameters
    probs <- generate_micro_curve(pars)

    ## Get daily actual incidence based on data
    inc <- rep(zikv/nh/inc_buckets, inc_buckets)/pars["incPropn"]

    ## Generate probability of observing a microcephaly case on a given day
    probM <- generate_probM_aux(inc, probs, pars["baselineProb"])

    ## Get subset of times for the data we have incidence data
    tmp_buckets <- buckets[which(startDays >= min(inc_start) & endDays <= max(inc_end))]
    tmp_births <- births[which(startDays >= min(inc_start) & endDays <= max(inc_end))]
    
    ## Need only buckets for 
    probM <- average_buckets(probM, tmp_buckets)

    ## Get daily observed microcephaly cases
    if(perCap) {
        probM <- probM*tmp_births*pars["propn"]
    } else {
        probM <- probM*pars["propn"]
    }
    
    tmpStart <- startDays[which(startDays >= min(inc_start) & endDays <= max(inc_end))]
    tmpEnd <- endDays[which(startDays >= min(inc_start) & endDays <= max(inc_end))]

    ## Reported on mean of start and end report day
    meanDays <- (tmpStart + tmpEnd)/2
    return(data.frame("x"=meanDays,"y"=probM))
}

generate_peak_time_table <- function(dat, incDat){
    all_states <- get_epidemic_states(dat)$include
    peakTimes <- rep(858,length(all_states))
    
    peakTimes[which(all_states == "pernambuco")] <- 804
    peakTimes[which(all_states == "bahia")] <- 855
    peakTimes[which(all_states == "riograndedonorte")] <- 862
    
    peakWidths <- rep(120,length(all_states))
    peakWidths[which(all_states == "pernambuco")] <- 60
    peakWidths[which(all_states == "bahia")] <- 60
    peakWidths[which(all_states == "riograndedonorte")] <- 60

    ## Actual peak times
    actualPeaks <- data.frame(local=convert_name_to_state_factor(
                                  c("bahia","pernambuco","riograndedonorte")),
                              peakTime=c(855,804,862),
                              stringsAsFactors = FALSE)
    
    peakTimes <- data.frame(local=convert_name_to_state_factor(all_states),
                            start=peakTimes-peakWidths/2,
                            end=peakTimes+peakWidths/2,
                            stringsAsFactors = FALSE)
    peakTimes <- merge(actualPeaks,peakTimes,by="local",all=TRUE)
    
    if(!is.null(incDat)){
        fariaPeaks <- ddply(incDat, c("local"), .fun=function(x) x[which.max(x$inc),"meanDay"])
        colnames(fariaPeaks) = c("local","peakTimeFaria")
        fariaPeaks <- data.frame(fariaPeaks,startFaria=fariaPeaks[,2]-30,endFaria=fariaPeaks[,2]+30,stringsAsFactors=FALSE)
        peakTimes <- merge(peakTimes, fariaPeaks, by="local",all=TRUE)
    }
    return(peakTimes)

}

#' @export
main_model_fits <- function(chainWD = "~/Documents/Zika/28.02.2017_chains/multi_all1/model_1",
                            datFile = "~/Documents/Zika/Data/allDat28.02.17.csv",
                            incDatFile = "~/Documents/Zika/Data/inc_data_120317.csv",
                            runs=200,
                            datCutOff=1214,
                            incScale=2000
                            ){
    setwd(chainWD)
    
    chain <- zikaProj::load_mcmc_chains(
        location = chainWD,
        asList = FALSE,
        convertMCMC = FALSE,
        unfixed = FALSE,
        thin = 10,
        burnin = 750000)
    
    parTab <- read_inipars()
    ts <- seq(0,3003,by=1)
    
    dat <- read.csv(datFile,stringsAsFactors=FALSE)
    incDat <- read.csv(incDatFile,stringsAsFactors=FALSE)
    tmp <- NULL
    tmpDat <- dat[dat$local %in% unique(parTab$local),]
    states <- unique(tmpDat$local)
    for(state in states){
        tmp[[state]] <- plot_setup_data(
            chain, tmpDat, incDat,
            parTab, ts, state,
            runs=runs,startDay=365,
            noWeeks=150,
            perCap=TRUE)
    }
    
    incDat$meanDay <- (incDat$startDay + incDat$endDay)/2
    incDat$local <- convert_name_to_state_factor(incDat$local)
    
    peakTimes <- generate_peak_time_table(dat,incDat)
   
  
    
    labels <- rep(getDaysPerMonth(3),4)
    labels <- c(0,cumsum(labels))
    labels_names <- as.yearmon(as.Date(labels,origin="2013-01-01"))
    
   
    microBounds <- NULL
    for(i in 1:length(tmp)) microBounds <- rbind(microBounds, tmp[[i]][["microBounds"]])
    incBounds <- NULL
    for(i in 1:length(tmp)) incBounds <- rbind(incBounds, tmp[[i]][["incBounds"]])
   
    dat$meanDay <- rowMeans(dat[,c("startDay","endDay")])
    dat <- dat[dat$startDay < datCutOff,]
    dat$local <- convert_name_to_state_factor(dat$local)
    microBounds$local <- convert_name_to_state_factor(microBounds$local)
    incBounds$local <- convert_name_to_state_factor(incBounds$local)

    inc_scales <- ddply(microBounds, "local", function(x) max(x$upper))

    ## Need to scale all of the incidence data for plotting purposes
    for(state in unique(incBounds$local)){
        scale <- as.numeric(inc_scales[inc_scales$local == state, 2])
        tmp_bounds <- incBounds[incBounds$local == state,]
        tmp_bounds[,c("lower","upper","best")] <- tmp_bounds[,c("lower","upper","best")] * incScale
        incBounds[incBounds$local == state,] <- tmp_bounds        
    }
    
    states <- unique(dat$local)
    #peakTimes <- peakTimes[peakTimes$local %in% states,]
    p <- ggplot() +
        geom_rect(data=peakTimes,
                  aes(xmin=start,xmax=end,ymin=0,ymax=Inf,group=local),
                  alpha=0.5,fill="red") +
        geom_rect(data=peakTimes,
                  aes(xmin=startFaria,xmax=endFaria,ymin=0,ymax=Inf,group=local),
                  alpha=0.5,fill="orange") +
        geom_vline(data=peakTimes,
                   aes(xintercept=peakTime,group=local),col="black",lty="dashed") +
        geom_ribbon(data=microBounds,aes(ymin=lower,ymax=upper,x=time),fill="blue",alpha=0.5) +
        geom_ribbon(data=incBounds,aes(ymin=lower,ymax=upper,x=time),fill="green",alpha=0.5) +
        geom_line(data=microBounds,aes(x=time,y=best),colour="blue") +
        geom_line(data=incBounds,aes(x=time,y=best),colour="green") +
        geom_point(data=dat, aes(x=meanDay, y = microCeph/births), size=0.6) +
        facet_wrap(~local,ncol=4) +
        scale_y_continuous(limits=c(0,0.02),breaks=seq(0,0.025,by=0.005),expand=c(0,0),
                           sec.axis=sec_axis(~.*(1/incScale)))+
        theme_bw() + 
        theme(axis.text.x=element_text(angle=90,vjust=0.5,size=8,family="Arial"),
              axis.text.y=element_text(size=8,family="Arial"),
              axis.title=element_text(size=10,family="Arial"),
              strip.text=element_text(size=8,family="Arial"),
              panel.grid.minor = element_blank()) +
        ylab("Per birth microcephaly incidence (blue)") +
        xlab("") +
        scale_x_continuous(breaks=labels,labels=labels_names)

     return(p)
}


indiv_model_fit <- function(chainWD = "~/Documents/Zika/28.02.2017_chains/northeast/model_1",
                           datFile = "~/Documents/Zika/Data/northeast_microceph.csv",
                           incFile = "~/Documents/Zika/Data/northeast_zikv.csv",
                           local = "bahia",
                           localName = "Northeast Brazil NEJM",
                           incScale=50,
                           runs=1000,
                           ylim=0.1,
                           bot=FALSE){
    ts <- seq(0,3003,by=1)
    setwd(chainWD)
    parTab <- read_inipars()
    chain <- zikaProj::load_mcmc_chains(location = chainWD,
                                        asList = FALSE,
                                        convertMCMC = FALSE,
                                        unfixed = FALSE,
                                        thin = 10,
                                        burnin = 750000)
  
    dat <- read.csv(datFile,stringsAsFactors = FALSE)
    dat <- dat[dat$local == local,]
    incDat <- NULL

    tmpDat <- read.csv("~/Documents/Zika/Data/allDat28.02.17.csv",stringsAsFactors=FALSE)
    tmpInc <- read.csv("~/Documents/Zika/Data/inc_data_120317.csv",stringsAsFactors=FALSE)
    tmpInc$meanDay <- rowMeans(tmpInc[,c("startDay","endDay")])
    tmpInc$local <- convert_name_to_state_factor(tmpInc$local)
    peakTimes <- generate_peak_time_table(tmpDat,tmpInc)
    peakTimes <- peakTimes[peakTimes$local == convert_name_to_state_factor(local),]
    if(!is.null(incFile)){
        incDat <- read.csv(incFile,stringsAsFactors=FALSE)    
        incDat <- incDat[incDat$local == local,]
        
        f <- create_f(parTab,dat,NULL,incDat=incDat, perCap=TRUE)
        
        samples <-  sample(nrow(chain), runs)
        microCurves <- NULL
        for(i in 1:length(samples)){
            pars <- get_index_pars(chain,samples[i])
            microCurves <- rbind(microCurves, f(pars))
        }
        
        predict_bounds <- as.data.frame(t(sapply(unique(microCurves$x),function(x) quantile(microCurves[microCurves$x==x,"y"],c(0.025,0.5,0.975)))[c(1,3),]))
        bestPars <- get_best_pars(chain)
        best_predict <- f(bestPars)
        predict_bounds <- cbind(predict_bounds, best_predict[,2])
        colnames(predict_bounds) <- c("lower","upper","best")
        predict_bounds$time <- best_predict[,1]
    }
 
    if(!(local %in% parTab$local)){
        dat$local <- "bahia"
        if(!is.null(incDat)) incDat$local <- "bahia"
        local <- "bahia"
    }
    dat <- dat[,c("startDay","endDay","microCeph","buckets","births","local")]
    if(!is.null(incDat)) incDat <- incDat[,c("startDay","endDay","buckets","inc","N_H","local")]

    labels <- rep(getDaysPerMonth(3),4)
    labels <- c(0,cumsum(labels))
    labels_names <- as.yearmon(as.Date(labels,origin="2013-01-01"))

    tmp <- plot_setup_data(chain, dat, incDat,parTab, ts, local,200,365, noMonths=36,noWeeks=150,perCap=TRUE)
    microBounds <- tmp[["microBounds"]]
    incBounds <- tmp[["incBounds"]]
    dat$meanDay <- rowMeans(dat[,c("startDay","endDay")])
    if(!is.null(incDat)){
        incDat$meanDay <- rowMeans(incDat[,c("startDay","endDay")])
      
        incDat$local <- localName
    }
    
    microBounds$local <- localName
    dat$local <- localName    
    incBounds[,c("lower","upper","best")] <- incBounds[,c("lower","upper","best")]
    incBounds$local <- localName
    peakTimes$local <- localName
    p <- ggplot() +
        geom_ribbon(data=microBounds,aes(ymin=lower,ymax=upper,x=time),fill="blue",alpha=0.5) +
        geom_ribbon(data=incBounds,aes(ymin=lower/incScale,ymax=upper/incScale,x=time),fill="green",alpha=0.5) +
        geom_line(data=microBounds,aes(x=time,y=best),colour="blue") +
        geom_line(data=incBounds,aes(x=time,y=best/incScale),colour="green")
    if(!is.null(incFile)){
        p <- p +
            geom_ribbon(data=predict_bounds,aes(ymin=lower,ymax=upper,x=time),fill="purple",alpha=0.5) +
            geom_line(data=predict_bounds,aes(x=time,y=best),colour="purple") +
            geom_line(data=incDat,aes(x=meanDay,y=inc/N_H/incScale),col="red",linetype="longdash")
    } else {
        p <- p +
            geom_rect(data=peakTimes,
                      aes(xmin=start,xmax=end,ymin=0,ymax=Inf,group=local),
                      alpha=0.5,fill="red") +
             geom_vline(data=peakTimes,
                        aes(xintercept=peakTime,group=local),col="black",lty="dashed")
    }
    p <- p + geom_point(data=dat, aes(x=meanDay, y = microCeph/births), size=0.6) +
        facet_wrap(~local,scales="free_y",ncol=1) +
        scale_y_continuous(limits=c(0,ylim),breaks=seq(0,ylim,by=ylim/5),expand=c(0,0),sec.axis=sec_axis(~.*(incScale),name="Reported ZIKV incidence (red)"))+
        theme_bw()
    if(bot){
        p <- p +
            theme(axis.text.y=element_text(size=8,family="Arial"),
                  axis.title.x=element_blank(),
                  axis.title=element_text(size=10,family="Arial"),
                  strip.text=element_text(size=8,family="Arial"),
                  axis.title.y=element_blank(),
                  axis.text.x=element_text(angle=90,hjust=0.5,size=8,family="Arial"), 
                  axis.ticks.x = element_blank(),
                  panel.grid.minor = element_blank())
    } else {
        p <- p +        
            theme(axis.text.y=element_text(size=8,family="Arial"),
                  axis.title.x=element_blank(),
                  axis.title=element_text(size=10,family="Arial"),
                  strip.text=element_text(size=8,family="Arial"),
                  axis.title.y=element_blank(),
                  axis.text.x=element_blank(), 
                  axis.ticks.x = element_blank(),
                  panel.grid.minor = element_blank())
    }
    p <- p +
        scale_x_continuous(limits=c(365,max(labels)),breaks=labels,labels=labels_names)+
        ylab("Reported microcephaly incidence (black)") +
        xlab("")
    return(p)
}


