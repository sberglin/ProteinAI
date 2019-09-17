################################################################################
##  Programmer: Mark V. Culp
##  Date:       10-26-2015
##  Purpose:    Demonstrate jointrls software on data. On a simplfied version  
##              of the simulated data.
##  Usage:      Should take a couple minutes to run.  
################################################################################


######
## Load packages and source the code
#####
library(glmnet)
source("http://www.stat.wvu.edu/~mculp/math/jmlr2/jt_code.R")
source("http://www.stat.wvu.edu/~mculp/math/jmlr2/extrap_tools.R")
scale.x=TRUE
sim="lucky" ## Set to lucky, unlucky or same

#######
## Set up data
#######

set.seed(100)
n=200
p=50
xL<-genL(n=floor(n/2),p=p)

mus<-c(rep(10,10),rep(0,p-10)) 
if(sim=="same")mus=0*mus ## uncomment for same
dat<-genU(ceiling(n/2),n-ceiling(n/2),xL,mus,0.6)

x<-dat$xf
L<-dat$L
U<-dat$U
xL=x[L,]
xU=x[U,]

bet<-c(0,rep(-1,5),rep(1,5),rep(0,p-10)) ##for lucky, same
if(sim=="unlucky")bet<-abs(bet) 


bet=bet*5/sqrt(10)
eps<-rnorm(length(L),0,7.5)
eps=eps-mean(eps)
yL=as.vector(cbind(1,x)[L,]%*%bet)+eps
y=rep(NA,n)
y[L]=yL

#####
## Run Superivsed 
#####


alphas=seq(0,1,length=57)
lalp=length(alphas)
tunes<-rep(0,lalp)
lams<-rep(0,lalp)
bsups<-NULL
for(i in 1:lalp){
	set.seed(10)
	g1<-cv.glmnet(x[L,],y[L],alpha=alphas[i])
	
	lams[i]=g1$lambda.min
	tunes[i]=min(g1$cvm)
	
    r=which.min(g1$cvm)
	bsup<-g1$glmnet.fit$beta[,r]
	bsups<-rbind(bsups,as.numeric(g1$glmnet.fit$beta[,r]))
}

sup.err=sqrt(mean(as.vector( x[U,]%*%(bsups[which.min(tunes),]-bet[-1]))^2))

#####
## Run Semi-superivsed (Should take about 2.25 minutes)
#####
gsemi<-cv.jointrls(y,x,fold=3,scale.x=scale.x)
semi.err<-sapply(1:dim(gsemi$bsemis)[2],
                function(i)sqrt(mean(as.vector(cbind(1,x)[U,]%*%(gsemi$bsemis[,i]-bet))^2)))[which.min(gsemi$mat$cverr)]


#####
## Display Errors
#####

round(sup.err,3)                        ##Supervised Error
round(semi.err,3)                       ##Semi-Supervised Error
round((sup.err-semi.err)/sup.err*100,3) ## %CV
