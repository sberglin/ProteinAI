#### Purpose ####
# This script creates a tuned Random Forest model for the original enzyme data.

# Loading Functions
source("Enzyme/functions/load_enzyme_data.R")
source("Enzyme/functions/rf_enzyme.R")

# Loading Data
original.enzyme = load("original/enzyme.txt")

# Creating Forest
forest = forest(original.enzyme)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)