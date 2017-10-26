# Clearing Workspace
rm(list = ls())

# Loading Data
source("functions/load_protein_data.R")
data = load("beta-lactamase/meyer_lactamase.txt")

# Gathering Possible Combinations
features = c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8")
combns = combn(features, 2)

# Establishing how many iterations of a given model will be averaged
# Since the model is built using a converging algorithm, it is slightly different each time. Hence, an averaged performance metrix is used to assess quality of the model
num.iterations = 10

# Record of averaged AIC values for each model
average.AICs = vector(mode = "numeric",
                      length = ncol(combns))
# Record of AIC value for each iteration of a given model
model.AICs = vector(mode = "numeric", length = num.iterations)


# For Each Combination, average the AIC of multiple models (since AIC slightly changes each time)
for (i in 1:ncol(combns)) {
    
    # Finding Proper Formula
    interaction.features = paste("(", combns[1,i], " + ",
                                 combns[2,i], ")^2", sep = "")
    single.features = features[!features %in% combns[, i]]
    formula = reformulate(termlabels = c(interaction.features,
                                  single.features),
                          response = "Functionality")
    
    
    # Assessing accuracy of multiple models
    for (j in 1:num.iterations) {
        
        # Creating the model
        log.model = glm(formula = formula, data = data, 
                        family = binomial(link = "logit"))
        # Recording AIC
        model.AICs[j] = log.model$aic
    }
    
 
    # Record averaged AIC
    average.AICs[i] = mean(model.AICs)
}

print(average.AICs)

# Matching AICs to pairwise combinations
# combns[3, ] = average.AICs