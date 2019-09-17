# TEST

#### Imports ####
library(readr)
library(Rtsne)
library(dplyr)
library(GGally)
library(repr)
library(e1071)
library(caret)

#### Reading lactamase filtered sequences as data frame ####
nat.raw = read_csv("Data/lactamase/lactamase_filtered.csv", col_names = F)
nat = data.frame(do.call(rbind, strsplit(nat.raw$X1, "")))
rm(nat.raw)

#### Reading positive and negative engineered lactamase sequences ####
# Reading all engineered sequences
eng.raw = read_csv("Data/lactamase/lactamase_seqs.csv", col_names = F)
eng = data.frame(do.call(rbind, strsplit(eng.raw$X1, "")))
rm(eng.raw)

# Getting labels
positives = read_csv("Data/lactamase/lactamase_func.csv", col_names = FALSE)$X1
positives = as.logical(positives)
cat(sum(positives), "positive examples and", sum(!positives), "negatives.")

# Splitting engineered to negatvie and positive
eng.pos = eng[positives, ]
eng.neg = eng[!positives, ]

#### Combining Data ####
nat.sub = sample_n(nat, size = 2500)
comb = rbind(eng.pos, eng.neg, nat.sub)
labels = as.factor(c(rep("Positive", nrow(eng.pos)), rep("Negative", nrow(eng.neg)), rep("Natural", nrow(nat.sub))))
colors = c(rep(1, nrow(eng.pos)), rep(2, nrow(eng.neg)), rep(3, nrow(nat.sub)))

#### Forming classifier data ####
n.min = min(sum(positives), round(0.5*sum(!positives)))
samples = c(sample(which(labels == "Positive"), n.min),
            sample(which(labels == "Negative"), 2*n.min),
            sample(which(labels == "Natural"), n.min))
bin.labels = as.factor(c(rep("Pos+Nat", nrow(eng.pos)),
                         rep("Neg", nrow(eng.neg)),
                         rep("Pos+Nat", nrow(nat.sub))))[samples]
true.labels.bin = c(rep("Positive", n.min), rep("Negative", 2*n.min),
                    rep("Natural", n.min))
classifier.data = cbind(bin.labels, comb[samples, ])
cat(n.min, "positives,", n.min, "naturals,", 2*n.min, "negatives.")

#### Cross validated Accuracy Estimate ####
folds = createFolds(classifier.data$bin.labels, k = 10)
test.acc = numeric(length(folds))
pos.acc = numeric(length(folds))
nat.acc = numeric(length(folds))
neg.acc = numeric(length(folds))
for (i in 1:length(folds)) {
    fold = folds[[i]]
    train = classifier.data[-fold, ]
    test = classifier.data[fold, ]
    NB = naiveBayes(bin.labels ~ ., data = train)
    preds = predict(NB, test, type = "class")
    test.acc[i] = mean(preds == test$bin.labels)
    fold.positives = true.labels.bin[fold] == "Positive"
    fold.naturals = true.labels.bin[fold] == "Natural"
    fold.negatives = true.labels.bin[fold] == "Negative"
    pos.acc[i] = mean((preds == test$bin.labels)[fold.positives])
    nat.acc[i] = mean((preds == test$bin.labels)[fold.naturals])
    neg.acc[i] = mean((preds == test$bin.labels)[fold.negatives])
}
cat("Overall 10-fold CV Accuracy =", mean(test.acc))
cat("Positive 10-fold CV Accuracy =", mean(pos.acc))
cat("Negative 10-fold CV Accuracy =", mean(neg.acc))
cat("Natural 10-fold CV Accuracy =", mean(nat.acc))
