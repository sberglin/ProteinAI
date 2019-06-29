#### Purpose ####
# Creates a random forest for the full P450 amino acid sequences

#### Clearing Workspace and loading functions/data ####
library(randomForest)
rm(list = ls())
source("P450/full AAseq/functions/load.R")
data = loadData()

#### Creating forest ####
weight = 0.5
forest = randomForest(x = data[,1:(ncol(data) - 1)],
                      y = as.factor(data$functionality),
                      cutoff = c(weight, 1 - weight))

#### Displaying forest statistics ####
print(forest)
cat("\nAccuracy of Predicted Functionality:", 
    forest$confusion[2,2] / sum(forest$confusion[,2]))
cat("\nProportion of Functional Proteins Predicted Correctly:",
    forest$confusion[2,2] / sum(forest$confusion[2,1:2]))

