#### Purpose ####
# Creates a random forest for the full beta-lactamase amino acid sequences

#### Clearing Workspace and loading functions/data ####
library(randomForest)
rm(list = ls())
source("datasets/beta-lactamase/full AAseq/functions/load.R")
data = loadData()

forest = randomForest(x = data[,1:(ncol(data) - 1)],
                      y = as.factor(data$functionality))
print(forest)