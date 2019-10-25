import torch
import gpytorch
from gpytorch.constraints import Positive
from .helpers import gardner_cdist

import pdb

class FlexKernel(gpytorch.kernels.Kernel):
    """ Kernel modified from 'Five dimensions, six parameters' section of the simulation study by Li."""
    
    def __init__(self, num_dims, lengthscales_prior = None, **kwargs):
        super().__init__(**kwargs)
        
        self.register_parameter(
            name = "raw_lengthscales",
            parameter = torch.nn.Parameter(torch.zeros(num_dims))
        )
        
        if lengthscales_prior is not None:
            self.register_prior(
                "lengthscales_prior",
                lengthscales_prior,
                lambda: self.lengthscales,
                lambda v: self.set_lengthscales(v)
            )
        
        self.register_constraint("raw_lengthscales", Positive())    
        
    @property
    def lengthscales(self):
        return self.raw_lengthscales_constraint.transform(self.raw_lengthscales)
    
    @lengthscales.setter
    def lengthscales(self, value):
        return self._set_lengthscales(value)
    
    def _set_lengthscales(self, value):
        if not torch.is_tensor(value):
            value = torch.as_tensor(value).to(self.raw_lengthscales)

        self.initialize(raw_lengthscales=self.raw_lengthscales_constraint.inverse_transform(value))
        
    # Computes the covariance between datasets x1 and x2. x1 is (n x d) and x2 is (m x d).
    def forward(self, x1, x2, **params):
        x1_scaled = torch.mm(x1, torch.diag(self.lengthscales))
        x2_scaled = torch.mm(x2, torch.diag(self.lengthscales))
        distances = gardner_cdist(x1_scaled, x2_scaled)
        return torch.exp(-1/2 * distances)
