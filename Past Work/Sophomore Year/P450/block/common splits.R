#### Purpose ####
# Finds the most common splits in a set of N decision trees. A set of decision trees is used rather than simpy a random forest since correlation between each tree is DESIRED

#### Loading Data, Functions, and Packages ####
library(rpart)
# Number of Trees to Grow
n = 5
# Functions
findNodeStructure = function(tree, node) {
    ancestors = unlist(path.rpart(tree, node, print.it = F))
    prediction = tree$frame[node, 5]
    return(append(ancestors, prediction))
}
createTree = function(data) {
    # Creating Tree from Test Data
    fit = rpart(formula = Functionality ~ ., data = data, method = "class", 
                control = rpart.control(cp = 0.00001))
    # Pruning Tree
    # Finding Range for xerrors
    min.xerror = fit$cptable[ which.min(fit$cptable[ , "xerror"]),"xerror"]
    min.xerror.xstd = fit$cptable[which.min(fit$cptable[ , "xerror"]),"xstd"]
    # Finding Simplest Model with 'Equivalent' Accuracy (within 1 std of min)
    strongest.model.index = min(which((fit$cptable[ , "xerror"] >= min.xerror -
        min.xerror.xstd) & (fit$cptable[ , "xerror"] <= min.xerror + 
        min.xerror.xstd)))
    # Pruning
    return(prune(fit, fit$cptable[strongest.model.index, "CP"]))
}
# Loading Data
source("functions/load_protein_data.R")
data = load("P450/block/enzyme.txt")
# Record of all split types
splits = list()

#### Finding Common Splits ####
for (i in 1:n) {
    # Creating the tree
    newTree = createTree(data)
    
    # Finding the most common splits
    
    # Finding indices of leaf nodes
    leafIndices = which(newTree$frame$var == "<leaf>")
    
    # For each leaf node
    for (leafIndex in leafIndices) {
        # Find the structure of it
        structure = findNodeStructure(newTree, leafIndex)
        # record it
        
    }
        
    
    
}


#### Documenting Each Split Choice of Each Tree ####
# for each tree in the forest
# for (tree in trees) {
#     # for each leaf node of the tree
#     leaves = which(tree$frame$var == "<leaf>")
#         # find the Node Structure
#         # if it exists in the current node structure bank
#             # incremement the matching structure count by one
#         # else
#             # add it to the structure bank with a count of one
# }

# a = findNodeStructure(pruned.fit, 2)
# leaves = which(structure$var == "<leaf>")

#### Finding Most Common Splits ####