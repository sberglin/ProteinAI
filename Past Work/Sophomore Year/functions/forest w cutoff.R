#### Purpose ####
# Creates a random forest model using R's randomForest pacakge for enzyme data.

library(randomForest)

create.forest <- function(data, adjusted.cutoff) {
 
    # Further Processing Data
    predictors = data[ , -which(names(data) == "Functionality")]
    responses = data$Functionality

    # Creating Tuned Forest
    forest = invisible(
        tuneRF(predictors, responses, stepFactor = 1.5, 
               improve = 0.005, plot = FALSE, trace = FALSE, 
               cutoff = c(adjusted.cutoff, 1 - adjusted.cutoff),
               doBest = TRUE))
    
    # Output from tuneRF cannot be hidden. Alerting of this in
    # console
    cat("Ignore numbers above. Used during parameter tuning",
        "and cannot hide.\n")
    
    return(forest)
}