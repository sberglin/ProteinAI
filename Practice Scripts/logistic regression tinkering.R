# Preparing Data

# Reading Data
training.data.raw <- read.csv('practice scripts/titanic.csv', header = T,
                              na.strings = c(""))
# Dropping Irrelevent Data Points
data <- subset(training.data.raw, select = c(2,3,5,6,7,8,10,12))
# Dealing with other missing points in data
# There exits a parameter in glm() for this, but the writer prefers to replace the NAs 'by hand' with the average point
data$Age[is.na(data$Age)] <- mean(data$Age, na.rm = T)
data <- data[!is.na(data$Embarked),]
# Removing Row Names
rownames(data) <- NULL
# Splitting Data into Training Set and Test Set
train <- data[1:800,]
test <- data[801:889,]


# Analyzing Data
model <- glm(Survived ~., family = binomial(link='logit'),
             data = train)
# Displaying Results
# print(summary(model))
# print(anova(model, test = "Chisq"))
# cat("\npR2 Results:\n")
# library("pscl")
# print(pR2(model))


# Testing Model on Test Data

# Predicting
fitted.results <- predict(model,newdata=subset(test,select=c(2,3,4,5,6,7,8)),type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
# Assessing and Displaying Accuracy
misClasificError <- mean(fitted.results != test$Survived)
cat(paste('Accuracy:',1-misClasificError))