#### Purpose ####
# This script uses simulations to determine the approximate ratio of functional enzymes to nonfucntional enzymes of the ones that are predicted to be functional

# Clearing Workspace
rm(list = ls())
# Loading Functions
source("functions/load_protein_data.R")
source("functions/rf_protein.R")


#### Parameters ####
# Data to test
data = load("P450/enzyme.txt")
# Number of cutoffs to assess within each range
n = 10


# Setting Up Cutoff Determination Process
cutoff.range = c(0.000001, 0.999999)
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


# Beginning Refinement Process (Focus the range of cutoffs to test onto the maximum ratio)
repeat {
    # center range around previous maximum. It will be either half the
    # previous margin, or the distance to the previous endpoint from the
    # center (whichever is smaller)
    new.center = cutoffs[which.max(ratios)]
    half.width = mean(cutoff.range) - cutoff.range[1]
    distance.to.nearest.endpoint = min(new.center - cutoff.range[1],
                                       cutoff.range[2] - new.center)
                                    - 0.000000001 # prevents the range from
                                                  # reaching 0
    new.margin = min(distance.to.nearest.endpoint, half.width)
    upper.bound = new.center + new.margin
    lower.bound = new.center - new.margin
    cutoff.range = c(lower.bound, upper.bound)

    # Determining New Cutoff Values
    cutoffs = seq(cutoff.range[1], cutoff.range[2],
                  length.out = n)

    # New record of Functionality Ratios
    ratios = vector(mode = "numeric", length = length(cutoffs))

    # Finding Functionality Ratios for each cutoff
    for (i in 1:length(cutoffs)) {
        # Creating Forest
        forest = create.forest(data, cutoffs[i])
        # Recording Functionality Ratio
        ratios[i] = forest$confusion[2,2] /
            (forest$confusion[1,2] + forest$confusion[2,2])
    }
    # Once the range is sufficiently small, break
    if (max(ratios) - min(ratios) < 0.02) {
        break
    }
}


# Displaying and storing refined prediction ratios
cat("Average Functionality Ratio:", mean(ratios))
cat("\nStandard Deviation:", sd(ratios))
functionality.ratios = data.frame(cutoffs, ratios)
plot(cutoffs, ratios, main = "cutoffs vs ratios")