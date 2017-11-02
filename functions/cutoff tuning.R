#### Purpose ####
# This script uses simulations to determine the approximate error ratio given a test cutoff

# Desired ratio: ~10.0

# Clearing Workspace
rm(list = ls())

# Cutoff to Test
cutoff = c(0.082)

# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
lactamase = load("P450/enzyme.txt")

# Record of Error Ratios
error.ratios = vector(mode = "numeric", length = 20)

# Finding Average Error Ratio
for (i in 1:length(error.ratios)) {
    # Creating Forest
    forest = create.forest(lactamase, cutoff)
    # Recording Error Ratio
    error.ratios[i] = forest$confusion[2,3] / forest$confusion[1,3]
}

# Displaying Final Error Ratio
cat("Average Error Ratio:", mean(error.ratios))
cat("\nStandard Deviation:", sd(error.ratios))