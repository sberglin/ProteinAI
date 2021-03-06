# This script creates an individual decsion tree for the cel9 data.

# Clearing Workspace and Loading Packages
library("rpart")
library("rpart.plot")

# Clearing Variables
rm(list = ls())

# Loading Data
source("small sets/cel5/load.R")
data = load()

# Creating Tree from Test Data
fit = rpart(formula = Functionality ~ .,  data = data, method = "class", 
            control = rpart.control(minsplit = nrow(data) / 20))

# Pruning Tree
# Finding Range for xerrors
min.xerror = fit$cptable[which.min(fit$cptable[ , "xerror"]),"xerror"]
min.xerror.xstd = fit$cptable[which.min(fit$cptable[ , "xerror"]),"xstd"]
# Finding Simplest Model with 'Equivalent' Accuracy
strongest.model.index = min(which((fit$cptable[ , "xerror"] >= min.xerror - min.xerror.xstd) & (fit$cptable[ , "xerror"] <= min.xerror + min.xerror.xstd)))
# Pruning
pruned.fit = prune(fit, fit$cptable[strongest.model.index, "CP"])
# Removing excess variables
rm(min.xerror, min.xerror.xstd, strongest.model.index)

# Displaying Output
prp(fit, main = "unpruned fit", type = 3)
prp(pruned.fit, main = "pruned fit")
cat("\nUnpruned Fit\n")
printcp(fit)
cat("\nPruned data\n")
printcp(pruned.fit)