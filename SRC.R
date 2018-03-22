library(randomForestSRC)

# Loading Data
source("functions/load_protein_data.R")
p450 = load("P450/block/enzyme.txt") 

rfsrc = rfsrc(Functionality ~ ., p450)
