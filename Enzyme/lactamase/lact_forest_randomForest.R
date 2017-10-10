
#### Purpose ####
# This script creates a Random Forest model for the lactamase data.

# Clearing Workspace
rm(list = ls())

# Loading Functions
source("Enzyme/functions/load_enzyme_data.R")
source("Enzyme/functions/rf_enzyme.R")

# Loading Data
lactamase = load("lactamase/meyer_lactamase.txt")

# Creating Forest
forest = forest(lactamase)

# Displaying Output
plot(forest, main = "Error Rates vs Number of Trees")
legend("topright", colnames(forest$err.rate), col = 1:3, 
       pch = 15)
print(forest)