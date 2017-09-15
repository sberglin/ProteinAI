# Creating Random Points
n = 100
x1 = rnorm(n); x2 = rnorm(n); x3 = rnorm(n)
# Response Created (with random noise)
y = 3 + 4*x1 + 5*x2 + 6*x3 + 7*x1*x2 + rnorm(n)
# Create Linear Model
m = lm(y ~ x1 + x2 + x3 + x1*x2)
# Displaying Model
print(summary(m))


# Using mtcars data
# m3 = lm(mpg ~ hp + wt + gear, data=mtcars)
# summary(m3)
# anova(m3)