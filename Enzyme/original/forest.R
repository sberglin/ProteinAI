# Creates a tuned Random Forest for the original enzyme data.


# Loading Packages
library("randomForest")


# Clearing Workspace
rm(list = ls())


# Loading Data
source("Enzyme/load_data.R")
enzymes = loadData()


# Finding optimal parameters
predictors = enzymes[ , 2:9]
responses = enzymes[ , 1]
tuning = tuneRF(predictors, responses, 2,
                stepFactor = 1.5, improve = 0.005,
                ntreeTry =  500)
tuned.mtry = tuning[which.min(tuning[ , "OOBError"]),
                    "mtry"]
# Determing Class Weighted Vector (used to prevent overfitting to the dominant class)
num.0 = sum(responses == "0")
num.1 = sum(responses == "1")
class.weights = c(num.0 / length(responses),
                  num.1 / length(responses))


# Creating Forest
forest = randomForest(Functionality ~ .,
                      data = enzymes,
                      subset = 1:nrow(enzymes),
                      mtry = tuned.mtry,
                      cutoff = class.weights)


# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)