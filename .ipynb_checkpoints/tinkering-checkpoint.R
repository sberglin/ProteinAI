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

# Splitting engineered to negatvie and positive
eng.pos = eng[positives, ]
eng.neg = eng[!positives, ]

#### Combining Data ####
nat.sub = sample_n(nat, size = 2500)
comb = rbind(eng.pos, eng.neg, nat.sub)
labels = as.factor(c(rep("Positive", nrow(eng.pos)), rep("Negative", nrow(eng.neg)), rep("Natural", nrow(nat.sub))))
colors = c(rep(1, nrow(eng.pos)), rep(2, nrow(eng.neg)), rep(3, nrow(nat.sub)))

# Forming classifier data
bin.labels = as.factor(c(rep("Pos+Nat", nrow(eng.pos)), rep("Neg", nrow(eng.neg)), rep("Pos+Nat", nrow(nat.sub))))
n.neg = sum(bin.labels == "Neg")
neg.samples = which(bin.labels == "Neg")
pos.nat.samples = sample(which(bin.labels == "Pos+Nat"), size = n.neg,
                         replace = F)
classifier.data = cbind(bin.labels, comb)[c(neg.samples, pos.nat.samples), ]
cat(sum(classifier.data$bin.labels=="Neg"), "negative samples and", 
    sum(classifier.data$bin.labels=="Pos+Nat"), "positive or natural samples.")

# Cross validation
folds = createFolds(classifier.data$bin.labels, k = 10)
test.acc = numeric(length(folds))
for (i in 1:length(folds)) {
    fold = folds[[i]]
    train = classifier.data[-fold, ]
    test = classifier.data[fold, ]
    NB = naiveBayes(bin.labels ~ ., data = train)
    preds = predict(NB, test, type = "class")
    test.acc[i] = mean(preds == test$bin.labels)
}
cat("10-fold CV Accuracy =", mean(test.acc))
