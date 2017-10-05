# Loading Packages
library("randomForest")

set.seed(999);

# Clearing Workspace
rm(list = ls())

# Loading Data
source("lactamase/load_lact_data.R")
lactamase = loadData()

# Creating Forest
forest = randomForest(Functionality ~ ., data = lactamase,
                      subset = 1:nrow(lactamase), mtry = 2)

# Tuning
predictors = lactamase[ , 2:9]
responses = lactamase[ , 1]

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# TODO: Automatically Tune Model (tune on mtry)
# TODO: Crazy class.error in confusion matrix -> way to fix this?