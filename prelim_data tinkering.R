# Removing Environmental Variables
rm(list = ls())

# Reading Data
data = read.csv("prelim_data.txt", header = FALSE,
                col.names = c("Features", "Functionality"),
                colClasses = c("character", "integer"))
# Converting Binary Functionality Vector to Logical
data$Functionality = as.logical(data$Functionality)