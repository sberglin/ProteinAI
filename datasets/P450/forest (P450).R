#### Purpose ####
# This script creates a tuned Random Forest model for the P450 data.

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
original.enzyme = load("P450/enzyme.txt")

# Setting Cutoff
# (calculated manually using 'cutoff tuning.R')
cutoff = 0.082

# Creating Forest
forest = create.forest(original.enzyme, cutoff)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)
# Displaying Error Ratio
cat("Error Ratio:",
    forest$confusion[2,3] / forest$confusion[1,3],
    "(False Negatives per False Positive)")