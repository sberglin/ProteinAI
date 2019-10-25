import torch
import copy
from sklearn.metrics import mean_squared_error
from collections import defaultdict

# "cdist" function from Gardner on https://github.com/pytorch/pytorch/issues/15253
# Calculates the pairwise distance matrix between tensors x1 and x2
@torch.jit.script
def gardner_cdist(x1, x2):
    x1_norm = x1.pow(2).sum(dim=-1, keepdim=True)
    x2_norm = x2.pow(2).sum(dim=-1, keepdim=True)
    res = torch.addmm(x2_norm.transpose(-2, -1), x1, x2.transpose(-2, -1), alpha=-2).add_(x1_norm)
    res = res.clamp_min_(1e-30).sqrt_()
    return res

# Averages the training y-values as a baseline MSE
def baseline_mse(train_y, test_y):
    train_mean = torch.mean(train_y).item()
    return mean_squared_error(test_y, [train_mean for i in test_y])

