library(rpart)
library(rpart.plot)

# set.seed(414)

# Loading and selecting dataset
source("functions/load_protein_data.R")
p450 = load("P450/block/enzyme.txt")
# lactamase = load("lactamase/block/meyer_lactamase.txt")
data = p450

# Function to Created Perturbed Trees
perturbed.tree = function(data) {

    #### Random subsetting pf data points ####
    p = 0.9   # Proportion of data used in subset
    sub = sample(1:nrow(data), p*nrow(data))

    #### Creating Tree from Test Data ####
    tree = rpart(formula = Functionality ~ ., data = data,
                 method = "class", subset = sub,
                 control = rpart.control(minsplit = 15, cp = 1e-10))

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
    pruned.tree = prune(tree, tree$cptable[strongest.model.index,
                                           "CP"])

    #### Assessing Accuracy of each tree ####
    full.pred = predict(tree, data[-sub, -1], type = "class")
    pruned.pred = predict(pruned.tree, data[-sub, -1], type = "class")
    tree$acc = mean(full.pred == data[-sub,1])
    pruned.tree$acc = mean(pruned.pred == data[-sub,1])

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
pdf("Misc/Perturbed Trees/full trees (p450).pdf")
layout(layout.matrix)
full.acc = vector(length = n, mode = "numeric")
for (i in 1:n) { 
    prp(full[[i]]) 
    full.acc[i] = full[[i]]$acc
}
dev.off()
# Plotting Pruned Trees
pdf("Misc/Perturbed Trees/pruned trees (p450).pdf")
layout(layout.matrix)
pruned.acc = vector(length = n, mode = "numeric")
for (i in 1:n) { 
    prp(pruned[[i]]) 
    pruned.acc[i] = pruned[[i]]$acc
}
dev.off()