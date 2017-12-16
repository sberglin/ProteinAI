#### Purpose ####
# This script creates a random forest using interaction features

# Loading Functions
library(dummies)
source("functions/load_protein_data.R")
source("functions/rf_protein.R")

# Loading Data
lactamase = load("beta-lactamase/meyer_lactamase.txt")
features = lactamase[,-1]

# Interaction Dummy Variable Matrix
singleDummies = dummy.data.frame(features, sep = ".")
interactions = as.formula(
    paste("~(", paste(names(singleDummies), collapse = " + ", sep = ""), ")^2",
          sep = ""))
intDummies = cbind.data.frame(lactamase[,1],
                              model.matrix(interactions, singleDummies)[,-1])
colnames(intDummies)[1] = "Functionality"

# Creating Forest
adjusted.cutoff = 0.333    # Determined in 'cutoff tuning.R'
forest = invisible(
    tuneRF(intDummies[,-1], intDummies[,1], stepFactor = 1.5, 
           improve = 0.005, plot = FALSE, trace = FALSE, 
           cutoff = c(adjusted.cutoff, 1 - adjusted.cutoff),
           doBest = TRUE))

# Displaying Forest
print(forest)
# Displaying Positive Prediction Accuracy
cat("Functionality Rate of Proteins Predicted to be Functional:",
    forest$confusion[2,2] / sum(forest$confusion[ , 2]), "\n")
