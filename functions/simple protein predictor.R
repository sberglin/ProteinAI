#### Purpose ####
# Triggers a prediction process for the user

prediction.process = function(forest) {
    
    cat("Predict from console (enter 'console') or from file ('file')?\n")
    prediction.type = readline(prompt = "Response: ")
    
    # Console Predictions
    if (tolower(prediction.type) == "console") {
        
        # prompt for individual prediction
        input = readline(
            prompt = "Enter features (ex 13213213): ")
        
        # Processing user input
        new.data = data.frame(row.names = c("new.data"))
        new.data$x1 = factor(x = substr(input, 1, 1),
                             levels = c("1", "2", "3"))
        new.data$x2 = factor(substr(input, 2, 2),
                             levels = c("1", "2", "3"))
        new.data$x3 = factor(substr(input, 3, 3),
                             levels = c("1", "2", "3"))
        new.data$x4 = factor(substr(input, 4, 4),
                             levels = c("1", "2", "3"))
        new.data$x5 = factor(substr(input, 5, 5),
                             levels = c("1", "2", "3"))
        new.data$x6 = factor(substr(input, 6, 6),
                             levels = c("1", "2", "3"))
        new.data$x7 = factor(substr(input, 7, 7),
                             levels = c("1", "2", "3"))
        new.data$x8 = factor(substr(input, 8, 8),
                             levels = c("1", "2", "3"))
        
        # Predict
        prediction = predict(forest, new.data, type = "vote")
        
        # Display
        cat("Class Votes (as proprotions)\n",
            "Nonfunctional:", prediction[1,1], 
            "   Functional:", prediction[1,2], "\n")
        
        # testing
        prediction.2 = predict(forest, new.data,
                               type = "response")
        cat(paste("Predicted Class:", prediction.2))
    
    # File Predictions
    } else if (tolower(prediction.type) == "file") {
        
        # prompt for proper file to read from
        cat("What file holds the feature data?\n",
            "Note: data must be in proper format (ex: 12312312\n")
        file.path = readline(prompt = "Relative path: ")
        
        # Read in file
        # Loading function to read data
        source("functions/load prediction features.R")
        data = load.prediction.features(file.path)
        
        # Prompt for 'verbose' parameter
        cat("Would you like to include confidence for each prediction?")
        input = readline(prompt = "Yes/No: ")
        
        # Predict for file
        # No need to include confidence, so simply predict
        if (tolower(input) == "no") {
            data$predictions = predict(forest, data)
        # Must inlcude confidence
        } else {
            
        }
        # write predictions to new file
        
        
    } else {
        cat("Improper input type indicated. No predictions made.")
    }
    
}
