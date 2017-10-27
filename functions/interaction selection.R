# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Gathering Possible Combinations
features = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8")
combns = data.frame(t(combn(features, 2)))
combns$var1 = combns$X1; combns$X1 = NULL
combns$var2 = combns$X2; combns$X2 = NULL
# Record of AIC for each pair
combns$AIC = vector(mode = "numeric", length = nrow(combns))

# For Each Combination, find the AIC of the resulting model (i.e. considering that combination for pairwise interactions)
for (i in 1:nrow(combns)) {
    
    # Finding Proper Formula
    interaction.features = paste("(", combns$var1[i], " + ",
                                 combns$var2[i], ")^2", sep = "")
    single.features = features[!features %in% c(combns$var1[i],
                                                combns$var2[i])]
    formula = reformulate(termlabels = c(interaction.features,
                                  single.features),
                          response = "Functionality")
    
    # Creating the model
    log.model = glm(formula = formula, data = data, 
                        family = binomial(link = "logit"))
 
    # Record averaged AIC
    combns$AIC[i] = log.model$aic
}

cat("3 Smallest AIC's:", sort(combns$AIC)[1:3], "\n")
cat("Smallest AIC Combination:", combns[which.min(combns$AIC), ])