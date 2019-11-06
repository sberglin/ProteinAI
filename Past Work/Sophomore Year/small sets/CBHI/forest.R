#### Purpose ####
# This script creates a Random Forest model for the CBHI block data.

# Clearing Workspace
rm(list = ls())
# Loading packages
library(randomForest)

#### Loading Data ####
source("small sets/CBHI/load.R")
data = load()

#### Creating Forest ####
cat("Creating Random Forest (CBHI)\n")
forest = randomForest(Functionality ~ ., data = data, ntree = 200)

#### Displaying Output ####
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, pch = 15)
print(forest)
# Displaying Positive Prediction Accuracy
cat("\nFunctionality Rate of Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[ , 2]), "\n")
# Displaying Percent of Functional Proteins Actually Predicted Functional
cat("Proportion of Functional Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[2,1:2]), "\n")
# Displaying Importance Scores
cat("\nImportance Scoring\n")
print(importance(forest))
