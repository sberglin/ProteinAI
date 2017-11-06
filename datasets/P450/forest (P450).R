#### Purpose ####
# This script creates a tuned Random Forest model for the P450 data.

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
original.enzyme = load("P450/enzyme.txt")

# Setting Cutoff
# (calculated manually using 'cutoff tuning.R')
cutoff = 0.02

# Creating Forest
cat("Creating Random Forest (P450)\n")
forest = create.forest(original.enzyme, cutoff)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# Displaying Error Ratio (Ratio of False Negatives to False
# Postives)
cat("Functionality Rate of Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[ , 2]), "\n")

# Triggering Prediction Process
cat("\nCLASSIFIER BUILT\n")
# run prediction process
source("functions/simple protein predictor.R")
prediction.process(forest)