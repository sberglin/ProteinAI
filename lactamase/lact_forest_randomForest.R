# Loading Packages
library("randomForest")

set.seed(2017);

# Clearing Workspace
rm(list = ls())

# Loading Data
source("lactamase/load_lact_data.R")
lactamase = loadData()

# Finding optimal parameters
predictors = lactamase[ , 2:9]
responses = lactamase[ , 1]
tuning = tuneRF(predictors, responses, 2,
                stepFactor = 1.5, improve = 0.005,
                ntreeTry =  500)
tuned.mtry = tuning[which.min(tuning[ , "OOBError"]),
                    "mtry"]

# Contructing Tuned Forest
forest = randomForest(Functionality ~ .,
                      data = lactamase,
                      subset = 1:nrow(lactamase),
                      mtry = tuned.mtry)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# TODO: Crazy class.error in confusion matrix -> way to fix this?