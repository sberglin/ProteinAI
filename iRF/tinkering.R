# Loading Packages
library(iRF)

# Loading Data
source("functions/load_protein_data.R")
p450 = load("P450/block/enzyme.txt")
lact = load("lactamase/block/meyer_lactamase.txt")
response = p450$Functionality
predictors = data.matrix(p450[,-1])

# Running iRF
iRF = iRF(predictors, response, interactions.return = 5)