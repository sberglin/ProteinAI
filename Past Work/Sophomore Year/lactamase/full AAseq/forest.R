#### Purpose ####
# Creates a random forest for the full beta-lactamase amino acid sequences

#### Clearing Workspace and loading functions/data ####
library(randomForest)
rm(list = ls())
source("lactamase/full AAseq/functions/load.R")
data = loadData()

#### Constructing Forest ####
weight = 0.1
# TESTING
weight = 0.5
forest = randomForest(x = data[,1:(ncol(data) - 1)],
                      y = as.factor(data$functionality),
                      cutoff = c(weight, 1 - weight))

#### Displaying Forest Statistics ####
print(forest)
cat("\nAccuracy of Predicted Functionality:", 
    forest$confusion[2,2] / sum(forest$confusion[,2]))
cat("\nProportion of Functional Proportions Predicted Correctly:",
    forest$confusion[2,2] / sum(forest$confusion[2,1:2]))

