################################################################################
##  Programmer: Mark V. Culp
##  Date:       2-18-2015
##  Purpose:    Demonstrate Geometric and Bound examples from the paper.
##           
################################################################################


######
## Load packages and set user defined flags
#####
library(MASS)
library(glmnet)
source("http://www.stat.wvu.edu/~mculp/math/jmlr2/jt_code.R")
source("http://www.stat.wvu.edu/~mculp/math/jmlr2/extrap_tools.R")

#######
## Set up data with type as one of "block","pure","1d","same",
##                                  "hidden", or "labeled".
#######
dat<-sim.data(type="block")  
x=dat$x
y=dat$y

####
## Plot Directions of Extrapolation
####
taus<-plot.extrap(x,y)
taus
####
## Plot coeficent plot -- (lam,alp) are glmnet lam,alpha parameters (takes time to run)
####
alp=0.0
lam=0.0

plot.coef(x,y,alp=alp,lam=lam)
