# Clearing Workspace
rm(list = ls())

# Loading packages
library(boot)

# Loading Data
source("functions/load_protein_data.R")
data = load("P450/enzyme.txt")

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
cv = cv.glm(data = data, glmfit = log.model)
cat("Leave-one-out CV error: ", cv$delta[1], "\n")