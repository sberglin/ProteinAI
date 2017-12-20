##### Purpose ####
# Loads enzyme data. Data is assumed to be in directory of respective enzyme work. (ex: within '/Research/datasets/beta-lactamse' directory)

load <- function() {
    
    # Intially Reading Data
    data = read.csv('small sets/cel9/cel9_function.txt', header = FALSE,
                    col.names = c("Features", "Functionality"),
                    colClasses = c("character", "integer"))
    
    # Converting Response Variable to Logical
    data$Functionality = factor(data$Functionality)
    
    # Adding Separate Columns for Each Position's
    # Amino Acid
    data$x1 = as.factor(substr(data$Features, 1, 1))
    data$x2 = as.factor(substr(data$Features, 2, 2))
    data$x3 = as.factor(substr(data$Features, 3, 3))
    data$x4 = as.factor(substr(data$Features, 4, 4))
    data$x5 = as.factor(substr(data$Features, 5, 5))
    data$x6 = as.factor(substr(data$Features, 6, 6))
    data$x7 = as.factor(substr(data$Features, 7, 7))
    data$x8 = as.factor(substr(data$Features, 8, 8))
    
    # Removing Features Column
    data$Features = NULL
    
    return(data)
}