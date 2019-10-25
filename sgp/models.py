import gpytorch
import torch
import numpy as np

from gpytorch.kernels import ScaleKernel, RBFKernel
from gpytorch.models import ExactGP
import gpytorch.settings as settings
from gpytorch.distributions import MultivariateNormal
from gpytorch.models.exact_prediction_strategies import prediction_strategy

from sgp.kernels import FlexKernel

import pdb

# This is a "stochastic" Gaussian process than can be trained on subsets of the
# training data, rather than the full training data itself. Can't actually be trained.
class SGP(ExactGP):
    
    def __init__(self, train_x, train_y, likelihood):
        super(SGP, self).__init__(train_x, train_y, likelihood)
        self.mean_module = None
        self.covar_module = None

    def forward(self, x):
        try:
            mean_x = self.mean_module(x)
            covar_x = self.covar_module(x)
        except TypeError:
            raise TypeError("No defined mean or covariance function.")
        return gpytorch.distributions.MultivariateNormal(mean_x, covar_x)
        
    # Return the parameters as a dictionary
    def get_parameters(self, raw = True, show = False):
        parameters, e = {}, ''
        for param_name, param, constraint in self.named_parameters_and_constraints():
            if not raw:
                param_name = param_name.replace('raw_', '')
            try:
                if constraint is not None and not raw:
                    value = constraint.transform(param)
                else:
                    value = param.item()
                if show:
                    print(f'   Parameter name: {param_name:42} value = {value}')
                parameters[param_name] = value
            except ValueError:
                print(f'   Parameter name: {param_name:42} shape = {param.data.shape}')
                for i, raw_value in enumerate(param.data):
                    if constraint is not None and not raw:
                        value = constraint.transform(raw_value)
                    else:
                        value = raw_value
                    if show:
                        print(f'{e:61} value = {value}')
                    parameters[param_name + '_' + str(i)] = value
        return parameters
                
    def count_parameters(self):
        i = 0
        for _, param in self.named_parameters():
            try:
                param.item()
                i += 1
            except ValueError:
                for value in param.data:
                    i += 1
        return i
    
    # This method exactly matches the __call__ method of ExactGP, except we don't require training on all training inputs 
    def __call__(self, *args, **kwargs):
        train_inputs = list(self.train_inputs) if self.train_inputs is not None else []
        inputs = [i.unsqueeze(-1) if i.ndimension() == 1 else i for i in args]

        # Training mode: optimizing
        if self.training:
            if self.train_inputs is None:
                raise RuntimeError(
                    "train_inputs, train_targets cannot be None in training mode. "
                    "Call .eval() for prior predictions, or call .set_train_data() to add training data."
                )
            res = super(ExactGP, self).__call__(*inputs, **kwargs)
            return res

        # Prior mode
        elif settings.prior_mode.on() or self.train_inputs is None or self.train_targets is None:
            full_inputs = args
            full_output = super(ExactGP, self).__call__(*full_inputs, **kwargs)
            if settings.debug().on():
                if not isinstance(full_output, MultivariateNormal):
                    raise RuntimeError("ExactGP.forward must return a MultivariateNormal")
            return full_output

        # Posterior mode
        else:
            if settings.debug.on():
                if all(torch.equal(train_input, input) for train_input, input in zip(train_inputs, inputs)):
                    warnings.warn(
                        "The input matches the stored training data. Did you forget to call model.train()?", UserWarning
                    )

            # Get the terms that only depend on training data
            if self.prediction_strategy is None:
                train_output = super(ExactGP, self).__call__(*train_inputs, **kwargs)

                # Create the prediction strategy for
                self.prediction_strategy = prediction_strategy(
                    train_inputs=train_inputs,
                    train_prior_dist=train_output,
                    train_labels=self.train_targets,
                    likelihood=self.likelihood,
                )

            # Concatenate the input to the training input
            full_inputs = []
            batch_shape = train_inputs[0].shape[:-2]
            for train_input, input in zip(train_inputs, inputs):
                # Make sure the batch shapes agree for training/test data
                if batch_shape != train_input.shape[:-2]:
                    batch_shape = _mul_broadcast_shape(batch_shape, train_input.shape[:-2])
                    train_input = train_input.expand(*batch_shape, *train_input.shape[-2:])
                if batch_shape != input.shape[:-2]:
                    batch_shape = _mul_broadcast_shape(batch_shape, input.shape[:-2])
                    train_input = train_input.expand(*batch_shape, *train_input.shape[-2:])
                    input = input.expand(*batch_shape, *input.shape[-2:])
                full_inputs.append(torch.cat([train_input, input], dim=-2))

            # Get the joint distribution for training/test data
            full_output = super(ExactGP, self).__call__(*full_inputs, **kwargs)
            if settings.debug().on():
                if not isinstance(full_output, MultivariateNormal):
                    raise RuntimeError("ExactGP.forward must return a MultivariateNormal")
            full_mean, full_covar = full_output.loc, full_output.lazy_covariance_matrix

            # Determine the shape of the joint distribution
            batch_shape = full_output.batch_shape
            joint_shape = full_output.event_shape
            tasks_shape = joint_shape[1:]  # For multitask learning
            test_shape = torch.Size([joint_shape[0] - self.prediction_strategy.train_shape[0], *tasks_shape])

            # Make the prediction
            with settings._use_eval_tolerance():
                predictive_mean, predictive_covar = self.prediction_strategy.exact_prediction(full_mean, full_covar)

            # Reshape predictive mean to match the appropriate event shape
            predictive_mean = predictive_mean.view(*batch_shape, *test_shape).contiguous()
            return full_output.__class__(predictive_mean, predictive_covar)
    
# SGP with standard RBG Kernel
class VanillaSGP(SGP):
    
    def __init__(self, train_x, train_y, likelihood):
        super(SGP, self).__init__(train_x, train_y, likelihood)
        self.mean_module = gpytorch.means.ConstantMean()
        self.covar_module = ScaleKernel(RBFKernel())
        
# SGP with separate lengthscales for each dimension. It is much more "flexible."
class FlexSGP(SGP):
    
    def __init__(self, train_x, train_y, likelihood):
        super(SGP, self).__init__(train_x, train_y, likelihood)
        self.mean_module = gpytorch.means.ConstantMean() 
        self.covar_module = ScaleKernel(FlexKernel(num_dims = train_x.shape[1]))
