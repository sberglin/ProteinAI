
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
cutoff = 0.493

# Creating Forest
forest = create.forest(lactamase, cutoff)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# Displaying Error Ratio
cat("Error Ratio:",
    forest$confusion[2,3] / forest$confusion[1,3],
    "(False Negatives per False Positive)")