#### Purpose ####
# Create logistic regression model for the P450 data.

# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("P450/Enzyme.txt")

# Creating Model
log.model = glm(
    # Forumula includes optimal pair to consider, determined from
    # interaction selection.R; hard coded below
    formula = Functionality ~ (x1 + x7)^2 + x2 + x3 + x4 + x5 
    + x6 + x8,
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