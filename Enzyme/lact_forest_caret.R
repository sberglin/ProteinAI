# Loading Packages
library(randomForest)
library(caret)

# Clearing Workspace
rm(list = ls())

# Loading Data
source("lactamase/load_lact_data.R")
lactamase = loadData()

set.seed(999)

# Creating Tuned Forest
control <- trainControl(method = "oob", search = "grid")
tune.grid <- expand.grid(mtry = c(1:8))
tuned.forest <- train(Functionality ~ ., data = lactamase,
                      method = "rf", metric = "Accuracy",
                      tuneGrid = tune.grid, trControl = control)


# Displaying Output
print(tuned.forest)
print(tuned.forest$finalModel)