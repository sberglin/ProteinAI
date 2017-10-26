# Creates a decision tree for the original enzyme data.

# Clearing Workspace and Loading Packages
library("rpart")
library("rpart.plot")


# Clearing Variables
rm(list = ls())


# Loading Data
source("Enzyme/load_data.R")
data = loadData()


# Creating Tree from Test Data
fit = rpart(
        formula = Functionality ~ x1 + x2 + x3 + x4 + x5
            + x6 + x7 + x8, 
        data = data, 
        method = "class", 
        control = rpart.control(cp = 0.00001))


# Pruning Tree


# Finding Range for xerrors
min.xerror = fit$cptable[
    which.min(fit$cptable[ , "xerror"]),"xerror"]
min.xerror.xstd = fit$cptable[
    which.min(fit$cptable[ , "xerror"]),"xstd"]
# Finding Simplest Model with 'Equivalent' Accuracy
strongest.model.index = min(which((fit$cptable[ , "xerror"] >= min.xerror - min.xerror.xstd) & (fit$cptable[ , "xerror"] <= min.xerror + min.xerror.xstd)))
# Pruning
pruned.fit = prune(fit,
                   fit$cptable[strongest.model.index,
                               "CP"])

# Displaying Output
prp(fit, main = "unpruned fit")
prp(pruned.fit, main = "pruned fit")
cat("\nError Report (Unpruned data)\n")
printcp(fit)
cat("\nError Report (Pruned data)\n")
printcp(pruned.fit)