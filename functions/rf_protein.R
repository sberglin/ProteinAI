#### Purpose ####
# Creates a random forest model using R's randomForest pacakge for enzyme data.

#### Assumptions ####
# - Data has been loaded through the load_enzyyme_data.R

library(randomForest)

create.forest <- function(data, adjusted.cutoff) {
    
    # Finding optimal parameters
 
    # Tuning mtry
    responses = data$Functionality
    predictors = data[ , -which(names(data) == "Functionality")]
    tuning = invisible(
        tuneRF(predictors, responses,
    stepFactor = 1.5, improve = 0.005,
               ntreeTry =  500, plot = FALSE,
               trace = FALSE))
    tuned.mtry = tuning[which.min(tuning[ , "OOBError"]), "mtry"]
    
    # Contructing Tuned and Weighted Forest
    forest = randomForest(Functionality ~ .,
                          data = data,
                          subset = 1:nrow(data),
                          mtry = tuned.mtry,
                          cutoff = c(adjusted.cutoff,
                                     1 - adjusted.cutoff))
    
    return(forest)
    
}