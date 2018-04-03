library(rpart)
library(rpart.plot)

# Loading and selecting dataset
source("functions/load_protein_data.R")
p450 = load("P450/block/enzyme.txt")
# lact = load("lactamase/block/meyer_lactamase.txt")
data = p450

# Function to Created Perturbed Trees
perturbed.tree = function(data) {
    
    #### Random subsetting pf data points ####
    p = 0.9   # Proportion of data used in subset
    sub = sample(1:nrow(data), p*nrow(data))
    
    #### Creating Tree from Test Data ####
    tree = rpart(formula = Functionality ~ ., data = data,
                 method = "class", subset = sub)
    
    #### Pruning Tree ####
    # Finding Simplest Model with 'Equivalent' Accuracy (within 1 SE of      minimum)
    min.xerror =  tree$cptable[ 
        which.min(tree$cptable[ , "xerror"]),"xerror"]
    min.xerror.xstd = tree$cptable[
        which.min(tree$cptable[ , "xerror"]),"xstd"]
    strongest.model.index = min(
        which((tree$cptable[ , "xerror"] >= min.xerror - min.xerror.xstd)
              & (tree$cptable[ , "xerror"] <= min.xerror +
                     min.xerror.xstd)))
    # Pruning
    pruned.tree = prune(tree, tree$cptable[strongest.model.index, "CP"])
    
    return(list(tree, pruned.tree))   
}

# Finding n perturbed trees (full and pruned versions)
n = 15
full = list()
pruned = list()
for (i in 1:n) {
    trees = perturbed.tree(data)
    full[[i]] = trees[[1]]
    pruned[[i]] = trees[[2]]
}

# Writing to pdf
layout.matrix = matrix(data = 1:n, nrow = 5, ncol = 3, byrow = T)
# Plotting Full Trees
pdf("Misc/Perturbed Trees/full trees.pdf")
layout(layout.matrix)
for (i in 1:n) { prp(full[[i]]) }
dev.off()
# Plotting Pruned Trees
pdf("Misc/Perturbed Trees/pruned trees.pdf")
layout(layout.matrix)
for (i in 1:n) { prp(pruned[[i]]) }
dev.off()