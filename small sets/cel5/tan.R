#### Purpose ####
# This script creates a Tree Augmented Naive Bayes (TAN) model for the block cel5 data.

# Clearing Workspace
rm(list = ls())

# Loading Functions and packages
library(bnlearn)
library(caret)
source("small sets/cel5/load.R")

# Loading Data
data = load()

# Constructing TAN Model
tanFit = tree.bayes(data, "Functionality")

# Assessing Accuracy
xValid = bn.cv(data, tanFit)
xValidAcc = vector(mode = "numeric", length = length(xValid))
for (i in 1:length(xValidAcc)) { xValidAcc[i] = xValid[[i]]$loss }
meanXValidAcc = 1 - mean(xValidAcc)
rm(i, xValidAcc)