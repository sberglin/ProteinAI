#### Purpose ####
# This script creates a tuned Random Forest model for the P450 block data.

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
original.enzyme = load("P450/block/enzyme.txt")

# Setting Cutoff
# (calculated manually using 'cutoff tuning.R')
cutoff = 0.02
cutoff = 0.5

# Creating Forest
cat("Creating Random Forest (P450)\n")
forest = create.forest(original.enzyme, cutoff)

#### Displaying Model ####
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)

# Displaying Error Ratio (Ratio of False Negatives to False
# Postives)
cat("\nFunctionality Rate of Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[ , 2]))
# Displaying Percent of Functional Proteins Actually Predicted Functional
cat("\nProportion of Functional Proteins Predicted Correctly:",
    forest$confusion[2,2] / sum(forest$confusion[2,1:2]))

# Displaying Importance Scores
cat("\nImportance Scoring\n")
print(importance(forest))


#### Triggering Prediction Process ####
# cat("\n\nCLASSIFIER BUILT\n")
# # run prediction process
# source("functions/simple protein predictor.R")
# # prediction.process(forest)