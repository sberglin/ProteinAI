#### Purpose ####
# This script creates a Tree Augmented Naive Bayes (TAN) model for the block P450 data.

# Clearing Workspace
rm(list = ls())

# Loading Functions and packages
library(bnlearn)
library(caret)
source("functions/load_protein_data.R")

# Loading Data
data = load("p450/block/enzyme.txt")

# Constructing TAN Model
tanFit = tree.bayes(data, "Functionality")

# Assessing Accuracy
xValid = bn.cv(data, tanFit)
xValidAcc = vector(mode = "numeric", length = length(xValid))
for (i in 1:length(xValidAcc)) { xValidAcc[i] = xValid[[i]]$loss }
meanXValidAcc = 1 - mean(xValidAcc)
rm(i, xValidAcc)