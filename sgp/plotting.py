import torch
from warnings import warn
from sklearn.metrics import mean_squared_error 

import pdb

def plot_function(ax, train_x, train_y, test_x, test_y, test_pred):
    
    # Check shapes. All tensors must be 1-dimensional for plotting
    if (len(train_x.shape), len(train_y.shape), 
        len(test_x.shape), len(test_pred.mean.shape)) != (1, 1, 1, 1):
        raise ValueError("All Tensors must be 1-dimensional.")
    
    # Plotting
    with torch.no_grad():
        # Get upper and lower confidence bounds
        lower, upper = test_pred.confidence_region()
        # Plot training data as black circles
        ax.plot(train_x.numpy(), train_y.numpy(), 'o', color = 'black')
        # Plot testing data as red circles
        ax.plot(test_x.numpy(), test_y.numpy(), 'o', color = 'red', mfc = 'none')
        # Plot predictive means as blue line
        ax.plot(test_x.numpy(), test_pred.mean.numpy(), 'b')
        # Shade between the lower and upper confidence bounds
        ax.fill_between(test_x.numpy(), lower.numpy(), upper.numpy(), alpha=0.5)
        ax.set_ylim([-1, 4])
        ax.legend(['Training Data', 'Testing Data', 'Prediction'])
        ax.set_xlabel("Chosen Input")
        ax.set_ylabel("Function Value")
        ax.set_title("Fitted Function")
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
        line = ax.plot(range(len(values)), values)[0]
        legend_names.append(name)
        if truths is not None:
            try:
                if truths[name] is not None:
                    ax.axhline(truths[name], linestyle = 'dashed', color = line.get_color())
                    legend_names.append('True ' + name)
            except KeyError:
                warn(f'No {name} key in "true" parameter dictionary. Skipping its line.')
    ax.legend(legend_names, bbox_to_anchor = (1, 0.75))
    ax.set_title('Parameter Convergence')
    ax.set_ylabel('Value')
    ax.set_xlabel('Iteration')
    return ax
