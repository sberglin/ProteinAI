rm(list = ls())

alligator = data.frame(
    InLength = 
        c(3.87, 3.61, 4.33, 3.43, 3.81, 3.83, 3.46, 3.76,
        3.50, 3.58, 4.19, 3.78, 3.71, 3.73, 3.78),
    InWeight =
        c(4.87, 3.93, 6.46, 3.33, 4.38, 4.70, 3.50, 4.50,
        3.58, 3.64, 5.90, 4.43, 4.38, 4.42, 4.25)
)

simple.reg.model = lm(formula = InWeight ~ InLength,
                      data = alligator)

plot(alligator$InLength, alligator$InWeight)
abline(simple.reg.model)

print(summary(simple.reg.model))