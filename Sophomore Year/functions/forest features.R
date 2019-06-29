#### Purpose ####
# Finds the most prevalent features within a random forest object.

find.features = function(forest) {
    tree = randomForest::getTree(forest, labelVar = T)
    cat("Number of nodes:", nrow(tree))
    
    
}
