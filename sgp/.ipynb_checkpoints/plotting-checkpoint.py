import torch
import numpy as np
from warnings import warn
from sklearn.metrics import mean_squared_error 

import pdb

def plot_function(ax, train_x, train_y, test_x, test_y, test_pred):
    
    # Check shapes. All tensors must be 1-dimensional for plotting
    if (len(train_x.shape), len(train_y.shape), 
        len(test_x.shape), len(test_pred.mean.shape)) != (1, 1, 1, 1):
        raise ValueError("All Tensors must be 1-dimensional.")
        
    # Changing data (not predictions) to numpy arrays
    train_x, train_y = train_x.numpy(), train_y.numpy()
    test_x, test_y = test_x.numpy(), test_y.numpy()
        
    # Sorting data (not predictions)
    train_o = np.argsort(train_x)
    test_o = np.argsort(test_x)
    train_x, train_y = train_x[train_o], train_y[train_o]
    test_x, test_y = test_x[test_o], test_y[test_o]
    
    # Plotting
    with torch.no_grad():
        # Get upper and lower confidence bounds
        lower, upper = test_pred.confidence_region()
        # Get predictive means
        mean = test_pred.mean
        # Converting to numpy and ordering
        mean, lower, upper = mean.numpy()[test_o], lower.numpy()[test_o], upper.numpy()[test_o]
        # Plot training data
        ax.plot(train_x, train_y)
        # Plot testing data
        ax.plot(test_x, test_y,)
        # Plot predictive means
        ax.plot(test_x, mean)
        # Shade between the lower and upper confidence bounds
        ax.fill_between(test_x, lower, upper, alpha=0.5)
        ax.legend(['Training Data', 'Testing Data', 'Prediction'])
        ax.set_xlabel("Chosen Input")
        ax.set_ylabel("Function Value")
        ax.set_title("Fitted Function")
        ax.set_ylim(min(np.min(lower), np.min(test_y), np.min(train_y)),
                    max(np.max(upper), np.max(test_y), np.max(train_y)))
        return ax
        
def plot_loss(ax, losses):
    try:
        ax.plot(range(len(losses)), losses)
    except TypeError:
        raise TypeError("losses must have a 'len' function.")
    ax.set_title("Loss Progression")
    ax.set_ylabel("Loss")
    ax.set_xlabel("Iteration")
    return ax

def plot_mses(ax, mses, baseline_mse):
    try:
        ax.plot(range(len(mses)), mses)
    except TypeError:
        raise TypeError("MSEs must have a 'len' function.")
    ax.axhline(baseline_mse, color = 'red')
    ax.legend(['MSE', 'MSE of Training Mean'])
    ax.set_title("MSE Progression")
    ax.set_ylabel("MSE")
    ax.set_xlabel("Iteration")
    return ax
    
def plot_parameters(ax, parameters, truths = None):
    legend_names = []
    for name, values in parameters.items():
        try:
            line = ax.plot(range(len(values)), values)[0]
            legend_names.append(name)
            if truths is not None:
                try:
                    if truths[name] is not None:
                        ax.axhline(truths[name], linestyle = 'dashed', color = line.get_color())
                        legend_names.append(f'True {name}')
                except KeyError:
                    warn(f'No {name} key in "true" parameter dictionary. Skipping its line.')
        except ValueError:
            # Multiple 'dimensions' in this parameter (ex: separate lengthscales for each dimension)
            dimensions = range(len(values[0]))
            reshaped_values = [[epoch[d].item() for epoch in values] for d in dimensions]
            for d, d_values in enumerate(reshaped_values):
                d_name = f'{name}_{d}'
                line = ax.plot(range(len(d_values)), d_values)[0]
                legend_names.append(d_name)
                if truths is not None:
                    try:
                        if truths[d_name] is not None:
                            ax.axhline(truths[d_name], linestyle = 'dashed', color = line.get_color())
                            legend_names.append(f'True {d_name}')
                    except KeyError:
                        warn(f'No {d_name} key in "true" parameter dictionary. Skipping its line.')
    ax.legend(legend_names, bbox_to_anchor = (1, 0.75))
    ax.set_title('Parameter Convergence')
    ax.set_ylabel('Value')
    ax.set_xlabel('Iteration')
    return ax
