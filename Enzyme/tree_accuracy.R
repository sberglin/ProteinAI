source("tree.R")

scores = vector(mode = "numeric", length = 100)

for (i in 1:100) {
    scores[i] = fit()
}

plot(density(scores))
cat("Mean:", mean(scores), "\n")
cat("Standard Deviation:", sd(scores))