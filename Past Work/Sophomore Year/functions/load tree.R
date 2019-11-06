#### Loads tree ####
library(data.tree)

#### Notes ####
# The tree yielded from the random forest sometimes produces "unecessary" nodes. That is, it splits on a variable, but then tests the same characteristic again on each side. This results from the partially randomized splitting done at each node. It is how the random forest model behaves (in an effort to reduce correlation between trees). This script 

# Character used in coding the characteristics of each node
separator = ":"

# Primary tree loading function
load.tree = function(tree) {
    
    # Load the root of the tree as a node
    rootData = paste(unlist(tree[1,3:6]), collapse = separator)
    root = Node$new(rootData, matrixIndex = 1)
    
    # Load the rest of the tree
    root = load.children(root, tree)
    
    return(root)
}

# Helper Function for load.tree
load.children = function(node, tree) {
    
    # If node has no children, simply return the loaded node
    if (tree[node$matrixIndex, 1] == 0) { return(node) }
    
    # If node has children, load each child
    
    # Indices of children to load within tree
    leftChildIndex = tree[node$matrixIndex, 1]
    rightChildIndex = tree[node$matrixIndex, 2]
    
    # Data of each child
    leftChildData = paste(unlist(tree[leftChildIndex, 3:6]),
                          collapse = separator)
    rightChildData = paste(unlist(tree[rightChildIndex, 3:6]),
                           collapse = separator)
    
    # Creating nodes for children
    newLeftChild = Node$new(leftChildData, matrixIndex = leftChildIndex)
    newRightChild = Node$new(rightChildData, matrixIndex = rightChildIndex)
    
    # Adding each child to the parent
    node$AddChildNode(load.children(newLeftChild, tree))
    node$AddChildNode(load.children(newRightChild, tree))
    
    return(node)
}

# DEV
source("functions/load_protein_data.R")
source("functions/rf_protein.R")
lactamase = load("beta-lactamase/meyer_lactamase.txt")
forest = create.forest(lactamase, 0.333)
rm(lactamase)
tree = randomForest::getTree(forest, labelVar = T)

A = load.tree(tree)
nodes = Traverse(A, traversal = "pre-order")
