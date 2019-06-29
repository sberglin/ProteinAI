#### Purpose ####
# Loads data into a data frame

loadData <- function() {
    
    # Loads feature data as a vector
    dataVector = as.character(
        read.csv(header = F,
                 'P450/full AAseq/AAseqs.txt')[,1])
    # Loads functionality data as a vector
    functionality = as.numeric(
        read.csv(
            header = F,
            'P450/full AAseq/AAseqsFunctionality.txt')[,1])
    
    # Data frame to ultimately be filled with data
    data = data.frame(matrix("", ncol = nchar(dataVector[1]), 
                             nrow = length(dataVector)))
    
    # Populating Data Frame
    for (i in 1:nchar(dataVector[1])) {
        data[,i] = as.factor(substring(dataVector, i, i))
    }
    
    # Adding functionality into data
    data$functionality = functionality
    
    return(data)
}

# x = loadData()