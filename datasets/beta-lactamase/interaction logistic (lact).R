# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")
# Splitting Training and Test Data
indices = list(train = sample(1:nrow(data), nrow(data) - 100))
indices$test = !(1:nrow(data) %in% indices$train)



# Creating Model
log.model = glm(formula = Functionality ~ (x1 + x2 + x3)^2 + x4 + x5 + x6 + x7 + x8,
                data = data[indices$train, ],
                family = binomial(link = "logit"))



# Displaying Model
print(summary(log.model))
cat("Number of Coefficients:", length(log.model$coefficients))



# Calculating Accuracy
predictions.percents = predict(log.model, 
                               data[indices$test, 2:9], 
                               type = "response")
predictions.discrete = predictions.percents >= 0.5
accuracy = sum(predictions.discrete == (data[indices$test, "Functionality"] == "1")) / length(predictions.discrete)
rm(predictions.discrete, predictions.percents)