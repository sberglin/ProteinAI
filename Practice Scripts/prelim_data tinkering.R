# Removing Environmental Variables
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

# Gathering Test Data


# Creating Tree
tree = rpart(formula = Functionality ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8,
             data = data, method = "class")

plot(tree)
text(tree)