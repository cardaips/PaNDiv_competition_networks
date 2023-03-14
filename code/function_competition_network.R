##list of functions :

#one network metric function ####
#diagonal dominance function
dominance <- function(alpha){
dom<-NA
for (i in 1:nrow(alpha)){
  ii<-alpha[row(alpha) == col(alpha)]
  diag(alpha)<-0
  ij<-alpha[i,]
  ij<-ij[ij!=0]
  d <- abs(ii[i]) - (sum(abs(ij)))
  dom<-rbind(dom,d)
}
dom<-dom[-1,]
dom<-mean(dom)
return(dom)
}


#remove combinations of species that are identical in two data frames ####
removeidentical<- function(alphai,beta){
  for (i in 1:ncol(alphai)) {
    m<-alphai[,i]
    for (j in 1:ncol(beta)) {
      n<-beta[,j]
      if (identical(m,n)){
        alphai[,i]<-NA
        i=i+1
      }
    }
  }
  alphai <- alphai[,colSums(is.na(alphai))<nrow(alphai)]
  colnames(alphai)<-NULL
  return(alphai)
}


# get all network metrics, formatted in a good way: all=competition matrix, dat= all combinations of species in the network ####
networkmetrics<-function(dat){
species<-data.frame(matrix(nrow=0,ncol = length(sp)))
colnames(species)<-sp
mixresults<-data.frame(Modularity=NA,
                       Skewness=NA,
                       Gini=NA,
                       Asymmetry=NA,
                       Diagstrength=NA,
                       SLA=NA,
                       SLAv=NA, 
                       Treatment = NA)
allresults<-data.frame(Modularity=NA,
                       Skewness=NA,
                       Gini=NA,
                       Asymmetry=NA,
                       Diagstrength=NA,
                       SLA=NA,
                       SLAv=NA, 
                       Treatment = NA)
  for (j in 1:length(all)) {
    m<-all[[j]]
    for (i in 1:ncol(dat)) {
      sps<-dat[,i]
      species[i,]<-ifelse(colnames(species) %in% sps,1,0)
      subalpha<-m[sps,sps]
      weight<-c(t(subalpha))
      sp2<-rep(sps,lenght.out = length(weight))
      sp1<-rep(sps,each=rich)
      net<-data.frame(sp1,sp2)
      g<-graph_from_data_frame(net)
      E(g)$weight<-weight
      clu<-cluster_optimal(g,weights = abs(E(g)$weight))
      mod<-modularity(g,membership(clu), weights = abs(E(g)$weight))
      mixresults[i,1]<-mod
      mixresults[i,2]<-skewness(c(subalpha))
      v<-c(subalpha)
      mixresults[i,3]<-Gini_RSV(y=v, w=rep(1, length(v)))
      asymmetry<-abs(subalpha-t(subalpha))
      diag(asymmetry)<-NA
      asymmetry<-lower.tri.remove(asymmetry)
      mixresults[i,4]<-mean(c(asymmetry), na.rm = T)
      diag<-dominance(subalpha)
      mixresults[i,5]<-diag
      mixresults[i,8]<-names(all)[j]
      meansla<-meansla2019[meansla2019$Species %in% sps,]
      mixresults[i,6]<- mean(meansla$value)
      mixresults[i,7]<- var(meansla$value)
    }
    allresults<-rbind(allresults,mixresults)
  }
  
  allresults<-allresults[-1,]
  allresults<-allresults %>% separate(Treatment, c('Season', 'Treatment'))
  allresults$Treatment<-as.factor(allresults$Treatment)
  allresults$Treatment<- factor(allresults$Treatment, levels=c("C", "N", "F", "NF"))
  allresults$Season<-as.factor(allresults$Season)
  allresults$Season<- factor(allresults$Season, levels=c("June", "August"))
  return(list(allresults,species))
}

# get network metrics for different levels of sp richness ####

networkrich<-function(n){
  allrich<-NA
  for (i in 1:length(n)){
    rich<-n[i]
    mixdat<-as.data.frame(combn(sp,rich))
    # (2) computing all network metrics for all functional communities
    all<-list(alpha_june_control,alpha_june_nitrogen,alpha_june_fungicide,alpha_june_combined,alpha_august_control,alpha_august_nitrogen,alpha_august_fungicide,alpha_august_combined)
    names(all)<-c("June C", "June N", "June F", "June NF", "August C", "August N", "August F", "August NF")
    
    mixnet<-networkmetrics(mixdat)
    speciesmixed<-mixnet[[2]]
    mixnet<-mixnet[[1]]
    mixnet$Communities<-"All"
    mixnet$Richness<-rich
    speciesmat<-speciesmixed[rep(rownames(speciesmixed),8),]
    rownames(speciesmat)<-NULL
    mixnet<-cbind(mixnet,speciesmat)
    allrich<-rbind(allrich,mixnet)
  }
  allrich<-allrich[-1,]
  return(allrich)
}


#prediction for SLA, model is the model used for prediction, comp is the original data set containing Nitrogen, Fungicide, SLA and Season
#returns a fit for the chosen network metrics with confidence intervals
slapred<- function(model, comp){

newdata<-NULL
sumboot<-NULL
SLA<-NULL
SLAv<-NULL
#create new data to predict on a new interval
SLA<-seq(min(comp$SLA), max(comp$SLA), length.out=100)
newdata <- expand.grid("SLA"=SLA, "Nitrogen" = c(0,1), "Fungicide" = c(0,1), "SLAv" = 0, "Season" = c("June","August"))
newdata$Nitrogen<-as.factor(newdata$Nitrogen)
newdata$Fungicide<-as.factor(newdata$Fungicide)
newdata$Treatment <- as.factor(paste(newdata$Nitrogen,newdata$Fungicide))
newSpecies <- rep(LETTERS[1:18], length.out= nrow(newdata))
newdata$Species<-newSpecies
levels(newdata$Treatment)<-c("Control","Fungicide","Nitrogen","Combined")
newdata$Treatment<-factor(newdata$Treatment, c("Control","Nitrogen","Fungicide","Combined"))

pfun <- function(.) {
  predict(., newdata=newdata, re.form=~0, type="response")
}

bootdata<-lme4::bootMer(model, pfun, nsim=100, type="parametric")
sumboot<-sumBoot(bootdata)

results<-cbind(newdata,sumboot)

return(results)
}


#prediction for SLA variance, model is the model used for prediction, comp is the original data set containing Nitrogen, Fungicide, SLA variance and Season
#returns a fit for the chosen network metrics with confidence intervals

slavpred<- function(model, comp){

newdata<-NULL
sumboot<-NULL
SLA<-NULL
SLAv<-NULL
#create new data to predict on a new interval
SLAv<-seq(min(comp$SLAv), max(comp$SLAv), length.out=100)
newdata <- expand.grid("SLAv"=SLAv, "Nitrogen" = c(0,1), "Fungicide" = c(0,1), "SLA" = 0, "Season" = c("June","August"))
newdata$Nitrogen<-as.factor(newdata$Nitrogen)
newdata$Fungicide<-as.factor(newdata$Fungicide)
newdata$Treatment <- as.factor(paste(newdata$Nitrogen,newdata$Fungicide))
newSpecies <- rep(LETTERS[1:18], length.out= nrow(newdata))
newdata$Species<-newSpecies
levels(newdata$Treatment)<-c("Control","Fungicide","Nitrogen","Combined")
newdata$Treatment<-factor(newdata$Treatment, c("Control","Nitrogen","Fungicide","Combined"))

pfun <- function(.) {
  predict(., newdata=newdata, re.form=~0, type="response")
}
bootdata<-lme4::bootMer(model, pfun, nsim=100, type="parametric")
sumboot<-sumBoot(bootdata)

vresults<-cbind(newdata,sumboot)

return(vresults)
}
