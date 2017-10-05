# Loading Packages
library("randomForest")

# Clearing Workspace
rm(list = ls())

# Loading Data
source("Enzyme/load_data.R")
enzymes = loadData()

# Creating Forest (Default is optimal tune)
forest = randomForest(
    Functionality ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 
        + x8,
    data = enzymes,
    subset = 1:nrow(enzymes))

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)