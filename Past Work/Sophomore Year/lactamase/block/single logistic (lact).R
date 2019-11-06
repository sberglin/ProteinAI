# Clearing Workspace
rm(list = ls())

# Loading packages
library(boot)

# Loading Data
source("functions/load_protein_data.R")
data = load("lactamase/block/meyer_lactamase.txt")

# Creating Model
log.model = glm(formula = Functionality ~ .,
                data = data,
                family = binomial(link = "logit"))

# Displaying Model
cat("Single Logistic Regression\n")
print(summary(log.model))
cat("AIC:", log.model$aic, "\n")
cat("Number of Coefficients:", length(log.model$coefficients), "\n")

# Displaying Accuracy
cat("Calculating cross validated accuracy...\n")
cv = cv.glm(data = data, glmfit = log.model, K = 10)
cat("10-fold CV Error: ", cv$delta[1], "\n")