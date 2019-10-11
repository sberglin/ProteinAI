import torch

def plot_function(ax, train_x, train_y, test_x, observed_pred):
    
    # Check shapes. All tensors must be 1-dimensional for plotting
    if (len(train_x.shape), len(train_y.shape), 
        len(test_x.shape), len(observed_pred.mean.shape)) != (1, 1, 1, 1):
        raise ValueError("All Tensors must be 1-dimensional.")
    
    # Plotting
    with torch.no_grad():
        # Get upper and lower confidence bounds
        lower, upper = observed_pred.confidence_region()
        # Plot training data as black stars
        ax.plot(train_x.numpy(), train_y.numpy(), 'o', color = 'black')
        # Plot predictive means as blue line
        ax.plot(test_x.numpy(), observed_pred.mean.numpy(), 'b')
        # Shade between the lower and upper confidence bounds
        ax.fill_between(test_x.numpy(), lower.numpy(), upper.numpy(), alpha=0.5)
        ax.set_ylim([-1, 4])
        ax.legend(['Observed Data', 'Predicted Mean', 'Confidence'])
        ax.set_xlabel("Chosen Input")
        ax.set_ylabel("Function Value")
        ax.set_title("Fitted Function")
        return ax
        
def plot_loss(ax, losses):
    try:
        ax.plot(range(len(losses)), losses)
    except TypeError:
        print("losses must have a 'len' function.")
    ax.set_title("Loss Progression")
    ax.set_ylabel("Loss")
    ax.set_xlabel("Iteration")
    return ax