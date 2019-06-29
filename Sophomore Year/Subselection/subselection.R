# This method compares the prediction error between a logistic regression model and a single tree when using only the top 3 positions for each set. This gives insight into how much the tree structure is helping, if at all.

library(rpart)

# Loading
source("functions/load_protein_data.R")
lactamase = load("lactamase/block/meyer_lactamase.txt")
p450 = load("P450/block/enzyme.txt")

# Subselecting only "important" variables (top 3)
# p450: x1, x5, x7    lactamase: x1, x3, x8
p450 = p450[,c("Functionality", "x1", "x5", "x7")]
lactamase = lactamase[, c("Functionality", "x1", "x3", "x8")]

# Creating Logistic Models for both
log.p450 = glm(formula = Functionality ~ ., data = p450,
               family = binomial(link = "logit"))
log.lact = glm(formula = Functionality ~ ., data = lactamase,
               family = binomial(link = "logit"))
# Creating Decision Trees for both
tree.p450 = rpart(formula = Functionality ~ ., data = p450, 
                  method = "class")
tree.lact = rpart(formula = Functionality ~ ., data = lactamase, 
                  method = "class")

# Retrieving Accuracies
cv.p450 = cv.glm(data = p450, glmfit = log.p450, K = 10)
cat("P450 Logistic 10-fold CV Error:", cv.p450$delta[1], "\n\n")
cv.lact = cv.glm(data = lactamase, glmfit = log.lact, K = 10)
cat("Lactamase Logistic 10-fold CV Error:", cv.lact$delta[1], "\n\n")
cat("P450 Tree Error Report\n")
printcp(tree.p450)
cat("\n")
cat("Lactamase Tree Error Report\n")
printcp(tree.lact)
