# Loading Packages
library("randomForest")

# Clearing Workspace
rm(list = ls())

# Loading Data
source("Enzyme/load_data.R")
enzymes = loadData()

# Testing Default Random Forest Model
error.rates = vector("numeric", length = 10)
for (i in 1:10) {
    # Build RF
    forest = randomForest(
        Functionality ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 
        + x8,
        data = enzymes,
        subset = 1:nrow(enzymes))
    specific.error.rate = forest$err.rate[500, 1]
    # Record Error Rate
    error.rates[i] = specific.error.rate
}
# Average Error Rates
min.error.rate = mean(error.rates)
# Record Used mtry
mtry = "default"

# Testing Other Models
# Testing 1-8 Attributes
for (i in c(1:8)) {
    
    error.rates = vector("numeric", length = 10)
    
    # Sample of 10 Random Forests
    for (j in 1:10) {
        # Build RF
        forest = randomForest(
            Functionality ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 
            + x8,
            data = enzymes,
            subset = 1:nrow(enzymes),
            mtry = i)
        specific.error.rate = forest$err.rate[500, 1]
        # Record Error Rate
        error.rates[j] = specific.error.rate
        # Record Used mtry
        m.try = i
    }
    
    # Averaging Error Rates
    specific.error.rate = mean(error.rates)
    
    if (specific.error.rate < min.error.rate) {
        min.error.rate = specific.error.rate
        mtry = m.try
    }
}