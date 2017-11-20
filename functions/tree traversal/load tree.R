#### Loads tree ####
library(data.tree)

# Primary tree loading function
load.tree = function(tree) {
    
    # Load the root of the tree as a node
    rootData = paste(unlist(tree[1,]), collapse = " ")
    root = Node$new(rootData, matrixIndex = 1)
    
    # Load the rest of the tree
    root = load.children(root, tree, 1)
    
    return(root)
}

# Helper Function for load.tree
load.children = function(node, tree, nodeIndex) {
    
    # If node has no children, simply return the loaded node
    if (tree[nodeIndex, 1] == 0) { return(node) }
    
    # If node has children, load each child
    
    # Indices of children to load within tree
    leftChildIndex = tree[nodeIndex, 1]
    rightChildIndex = tree[nodeIndex, 2]
    
    # Data of each child
    leftChildData = paste(unlist(tree[leftChildIndex,]), collapse = " ")
    rightChildData = paste(unlist(tree[rightChildIndex,]), collapse = " ")
    
    # Creating nodes for children
    newLeftChild = Node$new(leftChildData, matrixIndex = leftChildIndex)
    newRightChild = Node$new(rightChildData, matrixIndex = rightChildIndex)
    
    # Adding each child to the parent
    node$AddChildNode(load.children(newLeftChild, tree, leftChildIndex))
    node$AddChildNode(load.children(newRightChild, tree, rightChildIndex))
    
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
nodes = Traverse(A, traversal = "in-order")
