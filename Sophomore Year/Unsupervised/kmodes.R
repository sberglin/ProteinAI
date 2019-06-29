library(klaR)
library(cluster)

# Loading and selecting dataset
source("functions/load_protein_data.R")
p450 = load("P450/block/enzyme.txt")
# lactamase = load("lactamase/block/meyer_lactamase.txt")
data = p450[,-1]

cluster = function(data, k) {
    return(kmodes(data, k))
}

# Assessing Optimal K according to GAP statistic
x = clusGap(x = data, FUNcluster = cluster, K.max = 10)
# kmodes = kmodes(data, 4)

# plot(jitter(as.numeric(as.matrix(data))), col = kmodes$cluster)
