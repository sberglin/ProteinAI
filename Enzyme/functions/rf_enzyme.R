#### Purpose ####
# Creates a random forest model using R's randomForest pacakge for enzyme data.

#### Assumptions ####
# - Data has been loaded through the load_enzyyme_data.R

library(randomForest)

forest <- function(data) {
    
    # Finding optimal parameters
    
    # Tuning mtry
    responses = data$Functionality
    predictors = data[ , -which(names(data) == "Functionality")]
    tuning = tuneRF(predictors, responses,
                    stepFactor = 1.5, improve = 0.005,
                    ntreeTry =  500, plot = FALSE, trace = FALSE)
    tuned.mtry = tuning[which.min(tuning[ , "OOBError"]),
                        "mtry"]
    
    # Determing Class Weighted Vector
    # Used to prevent overfitting to the dominant class
    num.0 = sum(responses == "0")
    num.1 = sum(responses == "1")
    class.weights = c(num.0 / length(responses),
                      num.1 / length(responses))
    
    # Contructing Tuned and Weighted Forest
    forest = randomForest(Functionality ~ .,
                          data = data,
                          subset = 1:nrow(data),
                          mtry = tuned.mtry,
                          cutoff = class.weights)
    
    return(forest)
    
}