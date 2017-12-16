#### Purpose ####
# Create logistic regression model for the beta-lactamase data.

# Loading packages
library(boot)

# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Creating Model
log.model = glm(
    # Forumula includes optimal pair to consider, determined from
    # interaction selection.R; hard coded below
    formula = Functionality ~ (x1 + x8)^2 + x2 + x3 + x4 + x5 
    + x6 + x7,
    data = data,
    family = binomial(link = "logit"))

# Displaying Model
cat("Logistic Regression with Pairwise Interaction\n")
print(summary(log.model))
cat("AIC:", log.model$aic, "\n")
cat("Number of Coefficients:", length(log.model$coefficients), "\n")

# Calculating Accuracy
cat("Calculating cross validated accuracy...\n")
cv = cv.glm(data = data, glmfit = log.model)
cat("Leave-one-out error: ", cv$delta[1], "\n")