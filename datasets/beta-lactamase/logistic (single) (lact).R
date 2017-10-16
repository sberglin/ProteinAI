# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Gathering Training and Test Data
indices = list(train = sample(1:nrow(data), nrow(data) - 100))
indices$test = !(1:nrow(data) %in% indices$train)