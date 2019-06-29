# Loading Data
source("functions/load_protein_data.R")
data = load("P450/block/enzyme.txt")

# Creating Model
log.int = glm(
    # Forumula includes optimal pair to consider, determined from
    # interaction selection.R; hard coded below
    formula = Functionality ~ (x1 + x7)^2 + x2 + x3 + x4 + x5 
    + x6 + x8,
    data = data,
    family = binomial(link = "logit"))

# Displaying Model
cat("Logistic Regression with Pairwise Interaction\n")
print(summary(log.int))
cat("AIC:", log.int$aic, "\n")
cat("Number of Coefficients:", length(log.int$coefficients), "\n")

# Calculating Accuracy
cat("Calculating cross validated accuracy...\n")
cv = cv.glm(data = data, glmfit = log.int, K = 10)
cat("10-fold CV error: ", cv$delta[1], "\n")