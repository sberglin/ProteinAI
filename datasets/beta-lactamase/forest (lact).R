#### Purpose ####
# This script creates a Random Forest model for the lactamase data.

# Clearing Workspace
rm(list = ls())

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
lactamase = load("beta-lactamase/meyer_lactamase.txt")

# Adjusted Cutoff
# (calculated manually using 'cutoff tuning.R')
cutoff = 0.492

# Creating Forest
cat("Creating Random Forest (beta-lactamase)\n")
forest = create.forest(lactamase, cutoff)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# Displaying Error Ratio (Ratio of False Negatives to False
# Postives)
cat("Error Ratio:",
    forest$confusion[2,3] / forest$confusion[1,3],
    "(False Negatives per False Positive)\n")

# Triggering Prediction Prompt
cat("\nCLASSIFIER BUILT\n")
prediction.type = readline(prompt = "Predict from console (enter 'console') or from file ('file')? ")

if (tolower(prediction.type) == "console") {
    # prompt for individual prediction
    input = readline(prompt = "Enter features (ex 13213213) ")
    
    features = data.frame()
    
    # Processing user input
    x1 = as.factor(substr(features, 1, 1))
    x2 = as.factor(substr(features, 2, 2))
    x3 = as.factor(substr(features, 3, 3))
    x4 = as.factor(substr(features, 4, 4))
    x5 = as.factor(substr(features, 5, 5))
    x6 = as.factor(substr(features, 6, 6))
    x7 = as.factor(substr(features, 7, 7))
    x8 = as.factor(substr(features, 8, 8))
    
    
    
    # predict for it
    # prediction = predict
} else {
    # prompt for proper file to read from
    
    # Read in file
    
    # predict for file
    
    # write predictions to new file
}