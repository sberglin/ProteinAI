#### Purpose ####
# This script uses simulations to determine the approximate ratio of functional enzymes to nonfucntional enzymes of the ones that are predicted to be functional

# Clearing Workspace
rm(list = ls())
# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")


#### Parameters ####
# Data to test
data = load("beta-lactamase/meyer_lactamase.txt")
# Number of cutoffs to assess within each range
n = 10


# Setting Up Cutoff Determination Process
cutoff.range = c(0.0000001, 0.9999999)
# Determining Cutoff Values
cutoffs = seq(cutoff.range[1], cutoff.range[2], length.out = n)
# Record of Functionality Ratios
ratios = vector(mode = "numeric", length = length(cutoffs))
# Finding Functionality Ratios for each cutoff
for (i in 1:length(cutoffs)) {
    # Creating Forest
    forest = create.forest(data, cutoffs[i])
    # Recording Functionality Ratio
    ratios[i] = forest$confusion[2,2] / 
        (forest$confusion[1,2] + forest$confusion[2,2])
}


# # Beginning Refinement Process (Focus the range of cutoffs to test onto the maximum ratio)
# repeat {
#     # center new range around previous maximum. It will be half the width of
#     # the previous range
#     new.range.width = (cutoff.range[2] - cutoff.range[1]) / 2
#     new.center = cutoffs[which.max(ratios)]
#     distance.to.upper.endpoint = cutoff.range[2] - new.center
#     distance.to.lower.endpoint = new.center - cutoff.range[1]
#     distance.to.nearest.endpoint = min(distance.to.lower.endpoint,
#                                        distance.to.upper.endpoint)
#     # Finding proper endpoints for new range
#     # If the new center lies close to an endpoint, handle accordingly
#     if (abs(new.center - distance.to.nearest.endpoint) <= 
#         new.range.width / 2) {
#         if (distance.to.lower.endpoint <= new.range.width / 2) {
#             lower.bound = cutoff.range[1]
#             upper.bound = lower.bound + new.range.width
#         }
#         else if (distance.to.upper.endpoint <= new.range.width / 2) {
#             upper.bound = cutoff.range[2]
#             lower.bound = upper.bound - new.range.width
#         }
#     } else {
#     # If the new center is not close to an endpoint, simply adjust the
#     # new range
#         lower.bound = new.center - (new.range.width / 2)
#         upper.bound = new.center + (new.range.width / 2)
#     }
# 
#     # If range is sufficiently focused, leave loop
#     if (upper.bound - lower.bound < 0.02) {
#         break
#     }
#     
#     # Determining New Cutoff Values
#     cutoff.range = c(lower.bound, upper.bound)
#     cutoffs = seq(cutoff.range[1], cutoff.range[2],
#                   length.out = n)
# 
#     # New record of Functionality Ratios
#     ratios = vector(mode = "numeric", length = length(cutoffs))
#     
#     # Finding Functionality Ratios for each cutoff
#     for (i in 1:length(cutoffs)) {
#         # Creating Forest
#         forest = create.forest(data, cutoffs[i])
#         # Recording Functionality Ratio
#         ratios[i] = forest$confusion[2,2] /
#             (forest$confusion[1,2] + forest$confusion[2,2])
#     }
#     # Once the range is sufficiently small, break
#     if (max(ratios) - min(ratios) < 0.02) {
#         break
#     }
# }


# Displaying and storing refined prediction ratios
cat("Average Functionality Ratio:", mean(ratios))
cat("\nStandard Deviation:", sd(ratios))
functionality.ratios = data.frame(cutoffs, ratios)
plot(cutoffs, ratios, main = "cutoffs vs ratios")