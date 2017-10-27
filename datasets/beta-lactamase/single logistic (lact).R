# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Creating Model
log.model = glm(formula = Functionality ~ .,
                data = data,
                family = binomial(link = "logit"))

# Displaying Model
cat("Single Logistic Regression\n")
# print(summary(log.model))
cat("AIC:", log.model$aic, "\n")
cat("Number of Coefficients:", length(log.model$coefficients), "\n")

# Displaying Accuracy
cv = cv.glm(data = data, glmfit = log.model)
cat("Leave-one-out CV error: ", cv$delta[1], "\n")