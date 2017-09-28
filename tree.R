fit = function() {

# Clearing Workspace and Loading Packages
library("rpart")
library("rpart.plot")

# Clearing Variables
rm(list = ls())

# Reading Data
data = read.csv("data.txt", header = FALSE,
                col.names = c("Features", "Functionality"),
                colClasses = c("character", "integer"))

# Converting Binary Functionality Vector to Logical
data$Functionality = as.logical(data$Functionality)

# Adding Separate Columns for Each Position's Amino Acid
data$x1 = as.factor(substr(data$Features, 1, 1))
data$x2 = as.factor(substr(data$Features, 2, 2))
data$x3 = as.factor(substr(data$Features, 3, 3))
data$x4 = as.factor(substr(data$Features, 4, 4))
data$x5 = as.factor(substr(data$Features, 5, 5))
data$x6 = as.factor(substr(data$Features, 6, 6))
data$x7 = as.factor(substr(data$Features, 7, 7))
data$x8 = as.factor(substr(data$Features, 8, 8))

# Gathering Training and Testing Data
train.data.indices = sample(1:955, 855) 
train.data = data[train.data.indices, c(2:10)]
test.data.indices = !(c(1:955) %in% train.data.indices)


# Creating Tree from Test Data
fit = rpart(formula = Functionality ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8, data = train.data, method = "class", control = rpart.control(cp = 0.00001))

# Pruning Tree
# Finding Range for xerrors
min.xerror = fit$cptable[
    which.min(fit$cptable[ , "xerror"]),"xerror"]
min.xerror.xstd = fit$cptable[
    which.min(fit$cptable[ , "xerror"]),"xstd"]
# Finding Simplest Model with Equivalent Accuracy
strongest.model.index = min(which((fit$cptable[ , "xerror"] >= min.xerror - min.xerror.xstd) & (fit$cptable[ , "xerror"] <= min.xerror + min.xerror.xstd)))
# Pruning
pruned.fit = prune(fit, fit$cptable[strongest.model.index, "CP"])

# Displaying Output
# prp(fit, "unpruned fit"); prp(pruned.fit, main = "pruned fit"); printcp(fit)

# Assessing Accuracy of Model
predictions = 
    predict(pruned.fit, data[test.data.indices, c(2:10)],
            type = "class")
actual.values = data[test.data.indices, 2]
accuracy = sum((predictions == actual.values)) /
    length(predictions)

return(accuracy)
}