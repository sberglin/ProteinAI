# Loading packages
library(boot)

# Loading Data
source("functions/load_protein_data.R")
data = load("P450/block/enzyme.txt")

# Creating Model
log = glm(formula = Functionality ~ .,
                data = data,
                family = binomial(link = "logit"))

# Displaying Model
cat("Single Logistic Regression\n")
print(summary(log))
cat("AIC:", log$aic, "\n")
cat("Number of Coefficients:", length(log$coefficients), "\n")

# Displaying Accuracy
k = 10
cat("Calculating cross validated accuracy...\n")
cv = cv.glm(data = data, glmfit = log, K = k)
cat(k, "-fold CV Error: ", cv$delta[1], "\n", sep = "")