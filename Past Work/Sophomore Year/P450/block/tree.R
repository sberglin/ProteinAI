#### Purpose ####
# Creates a decision tree for the original enzyme data.

#### Loading Libraries and Data ####
# Clearing Workspace and Loading Packages
library("rpart")
library("rpart.plot")
# Clearing Variables
rm(list = ls())
# Loading Data
source("functions/load_protein_data.R")
data = load("P450/enzyme.txt")


#### Creating Tree ####
# Creating Tree from Test Data
fit = rpart(formula = Functionality ~ ., data = data, method = "class", 
        control = rpart.control(cp = 0.00001))


#### Pruning Tree ####
# Finding Range for xerrors
min.xerror = fit$cptable[ which.min(fit$cptable[ , "xerror"]),"xerror"]
min.xerror.xstd = fit$cptable[which.min(fit$cptable[ , "xerror"]),"xstd"]
# Finding Simplest Model with 'Equivalent' Accuracy (within 1 std of minimum)
strongest.model.index = min(which((fit$cptable[ , "xerror"] >= min.xerror - min.xerror.xstd) & (fit$cptable[ , "xerror"] <= min.xerror + min.xerror.xstd)))
# Pruning
pruned.fit = prune(fit, fit$cptable[strongest.model.index, "CP"])
# Removing excess variables
rm(min.xerror, min.xerror.xstd, strongest.model.index)

##### Displaying Output ####
prp(fit, main = "unpruned fit")
prp(pruned.fit, main = "pruned fit")
cat("\nError Report (Unpruned data)\n")
printcp(fit)
cat("\nError Report (Pruned data)\n")
printcp(pruned.fit)
