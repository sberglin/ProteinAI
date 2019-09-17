################################################################################
##  Programmer: Mark V. Culp
##  Date:       10-26-2015
##  Purpose:    Demonstrate jointrls software on data using the Auto-MPG Data.
##  Usage:      Should take a couple minutes to run.  
################################################################################


######
## Load packages and set user defined flags
#####
library(glmnet)
source("http://www.stat.wvu.edu/~mculp/math/jmlr2/jt_code.R")
scale.x=TRUE
P1=!TRUE     ##Set cars version


#######
## Set up data with median imputation, download from UCI repository.
#######

dat<-read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data",F,na.strings="?")
dim(dat)

na.median<-function(x,...){
    handle.na<-function(x){ #plug the median into missing values
        x[is.na(x)]<-median(x,na.rm=TRUE)
        return(x)
    }
    p<-dim(x)
    if(is.null(p)){ #special case: `x' is a vector
        return(handle.na(x))
    }
    for(i in 1:p[2]){
        if(!is.factor(x[,i]))# if `x' is a factor ignore it
        x[,i]<-handle.na(x[,i])
    }
    return(x)
}

dat<-na.median(dat)


if(P1){
    mx<-dat[,8]
    x=dat[,-c(8,9)]
    yt=dat[,1]
    x=as.matrix(x[,-1])
    L=which(mx>1)
    U=which(mx<2)
}else{
    mx<-dat[,2]
    x=dat[,-c(2,9)]
    yt=dat[,1]
    x=as.matrix(x[,-1])
    L=which(mx<5)
    U=which(mx>4)
}


n=dim(x)[1]
p=dim(x)[2]
y=yt
y[U]=NA


#####
## Run Superivsed 
#####

alphas=seq(0,1,length=57)
lalp=length(alphas)
gam=0.000000001
tunes<-rep(0,lalp)
lams<-rep(0,lalp)
bsups<-NULL
for(i in 1:lalp){
    set.seed(10)
    g1<-jointrls(y,x,lam=NULL,alp=alphas[i],gam=gam,scale.x=scale.x)
    bsup<-g1$bsemi
    bsups<-rbind(bsups,bsup)
    lams[i]=g1$lam
    tunes[i]=g1$err
}
k<-which.min(tunes)
lam=lams[k]
alp=alphas[k]
bsup=bsups[k,]
f<-as.vector(cbind(1,x)[U,]%*%bsup)
sup.err=sqrt(mean((f-yt[U])^2))

#####
## Run Semi-superivsed (Should take between 0.8 to 1.3 minutes -- took 0.8 on my machine in BATCH mode)
#####
alphas=sort(unique(c(0,1,0.25,0.5,0.75,alp)))
gsemi<-cv.jointrls(y,x,alpha=alphas,fold=3,scale.x=scale.x)
semi.err<-sapply(1:dim(gsemi$bsemi)[2],
                function(i)sqrt(mean ( (as.vector(cbind(1,x)[U,]%*%gsemi$bsemi[,i])-yt[U])^2)))[which.min(gsemi$mat$cverr)]



#####
## Display Errors
#####

round(sup.err,3)                        ##Supervised Error
round(semi.err,3)                       ##Semi-Supervised Error
round((sup.err-semi.err)/sup.err*100,3) ## %CV

######
##Get Same superivsed using glmnet directly
#####
l=length(L)
gsup<-glmnet(x[L,],y[L],lambda=lam*sqrt(var(y[L])*(l-1)/l),alpha=alp,standardize=scale.x)
f1=cbind(1,x)[U,]%*%coef(gsup)
sup.err-sqrt(mean((f1-yt[U])^2)) ## should be zero


