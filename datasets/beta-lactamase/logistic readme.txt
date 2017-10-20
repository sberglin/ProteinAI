BETA-LACTAMASE LOGISTIC REGRESSION NOTES

- variable coded as a 1 (lowest) is used as reference variable
- model very unstable, AIC varies by a lot (+- ~20)
- when regressing with pairwise interactions, overfits when considering interactions between more than 2 variables (this is due to the many different variables needed to characterize the 3 levels of each position, rather than just a binary yes/no for each position)