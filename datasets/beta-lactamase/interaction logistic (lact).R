#### Purpose ####
# Create logistic regression model for the beta-lactamase data.

# Clearing Workspace
# rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Creating Model
log.model = glm(
    formula = Functionality ~ (x7 + x8)^2 + x4 + x3 + x5 +
        x6 + x1 + x2,
    data = data,
    family = binomial(link = "logit"))

# Displaying Model
cat("Logistic Regression with Pairwise Interaction\n")
# print(summary(log.model))
cat("AIC:", log.model$aic, "\n")
cat("Number of Coefficients:", length(log.model$coefficients), "\n")

# Calculating Accuracy
cv = cv.glm(data = data, glmfit = log.model)
cat("Leave-one-out error: ", cv$delta[1], "\n")