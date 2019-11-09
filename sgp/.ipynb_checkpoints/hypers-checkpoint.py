import torch.optim.lr_scheduler
import torch.optim

class Hypers:
    
    def __init__(self, optim = torch.optim.SGD, optim_hypers = {},
                 scheduler = torch.optim.lr_scheduler.LambdaLR, scheduler_hypers = {'lr_lambda':lambda epoch: 1},
                 initialize = None):
        self._optim = optim
        self._optim_hypers = optim_hypers
        self._scheduler = scheduler
        self._scheduler_hypers = scheduler_hypers
        self._initialize = initialize
        
    @property
    def optim(self):
        return self._optim

    @optim.setter
    def optim(self, optim):
        self._optim = optim

    @property
    def optim_hypers(self):
        return self._optim_hypers

    @optim_hypers.setter
    def optim_hypers(self, optim_hypers):
        self._optim_hypers = optim_hypers

    @property
    def scheduler(self):
        return self._scheduler

    @scheduler.setter
    def scheduler(self, scheduler):
        self._scheduler = scheduler

    @property
    def scheduler_hypers(self):
        return self._scheduler_hypers

    @scheduler_hypers.setter
    def scheduler_hypers(self, scheduler_hypers):
        self._scheduler_hypers = scheduler_hypers

    @property
    def initialize(self):
        return self._initialize

    @initialize.setter
    def initialize(self, initialize):
        self._initialize = initialize
    