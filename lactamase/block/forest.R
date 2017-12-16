#### Purpose ####
# This script creates a Random Forest model for the block lactamase data.

# Clearing Workspace
rm(list = ls())

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
lactamase = load("lactamase/block/meyer_lactamase.txt")

# Adjusted Cutoff
# (calculated manually using 'cutoff tuning.R')
cutoff = 0.333
# TESTING
cutoff = 0.5

# Creating Forest
cat("Creating Random Forest (beta-lactamase)\n")
forest = create.forest(lactamase, cutoff)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# Displaying Positive Prediction Accuracy
cat("\nFunctionality Rate of Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[ , 2]), "\n")
# Displaying Percent of Functional Proteins Actually Predicted Functional
cat("Proportion of Functional Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[2,1:2]), "\n")

# Triggering Prediction Prompt
cat("\nCLASSIFIER BUILT\n")
# run prediction process
source("functions/simple protein predictor.R")
# prediction.process(forest) NOT FINISHED YET

# Attempting to Locate Most Common Splits
# DEV
tree = randomForest::getTree(forest, labelVar = T)
cat("Number of nodes:", nrow(tree))
