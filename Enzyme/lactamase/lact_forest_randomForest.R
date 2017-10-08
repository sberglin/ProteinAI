# This package creates a Random Forest model for the lactamase data.


# Loading Packages
library("randomForest")


# Clearing Workspace
rm(list = ls())


# Loading Data
source("lactamase/load_lact_data.R")
lactamase = loadData()


# Finding optimal parameters
# Tuning mtry
predictors = lactamase[ , 2:9]
responses = lactamase[ , 1]
tuning = tuneRF(predictors, responses, 2,
                stepFactor = 1.5, improve = 0.005,
                ntreeTry =  500)
tuned.mtry = tuning[which.min(tuning[ , "OOBError"]),
                    "mtry"]
# Determing Class Weighted Vector
# Used to prevent overfitting to the dominant class
num.0 = sum(responses == "0")
num.1 = sum(responses == "1")
class.weights = c(num.0 / length(responses),
                  num.1 / length(responses))


# Contructing Tuned and Weighted Forest
forest = randomForest(Functionality ~ .,
                      data = lactamase,
                      subset = 1:nrow(lactamase),
                      mtry = tuned.mtry,
                      cutoff = class.weights)


# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)