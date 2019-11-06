# Collection of optimization hyperparameters
class Hypers:
    
    def __init__(self, lr, momentum = 0, dampening = 0, weight_decay = 0, nesterov = False, 
                 lr_lambda = lambda epoch: 1,
                initialize = None):
        self._sgd = {'lr':lr,
                   'momentum':momentum,
                   'dampening':dampening,
                   'weight_decay':weight_decay,
                   'nesterov':nesterov}
        self._lambda_lr = lr_lambda
        self._initialize = initialize
        
    @property
    def sgd(self):
        return self._sgd
    
    @sgd.setter
    def sgd(self, dictionary):
        self._sgd = dictionary
    
    @property
    def lambda_lr(self):
        return self._lambda_lr
    
    @lambda_lr.setter
    def lambda_lr(self, function):
        self._lambda_lr = function
    
    @property
    def initialize(self):
        return self._initialize
    
    @initialize.setter
    def initialize(self, function):
        self._initialize = function
    