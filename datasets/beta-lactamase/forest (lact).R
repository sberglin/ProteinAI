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
# run prediction process
source("functions/simple protein predictor.R")
prediction.process(forest)