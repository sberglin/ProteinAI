##### Purpose ####
# Loads enzyme data to prediction functionality. Data is assumed to be in directory of project itself.

load.prediction.features <- function(path) {
    
    # Intially Reading Data
    data = read.csv(path, header = FALSE,
                    col.names = "Features",
                    colClasses = "character")
    
    # Adding Separate Columns for Each Position's
    # Amino Acid
    data$x1 = factor(substr(data$Features, 1, 1), levels = c("1", "2", "3"))
    data$x2 = factor(substr(data$Features, 2, 2), levels = c("1", "2", "3"))
    data$x3 = factor(substr(data$Features, 3, 3), levels = c("1", "2", "3"))
    data$x4 = factor(substr(data$Features, 4, 4), levels = c("1", "2", "3"))
    data$x5 = factor(substr(data$Features, 5, 5), levels = c("1", "2", "3"))
    data$x6 = factor(substr(data$Features, 6, 6), levels = c("1", "2", "3"))
    data$x7 = factor(substr(data$Features, 7, 7), levels = c("1", "2", "3"))
    data$x8 = factor(substr(data$Features, 8, 8), levels = c("1", "2", "3"))
    
    # Removing Features Column
    data$Features = NULL
    
    return(data)
    
}