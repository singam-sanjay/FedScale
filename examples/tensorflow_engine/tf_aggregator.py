import sys, os

sys.path.insert(1, os.path.join(sys.path[0], '../../'))
from fedscale.core.aggregator import Aggregator
from fedscale.core.fl_aggregator_libs import *
import tensorflow as tf

class Customized_Aggregator(Aggregator):
    """Feed aggregator using tensorflow models"""
    def __init__(self, args):
        super().__init__(args)

    def init_model(self):
        """Load model"""
        # CIFAR-10 as example
        self.model = tf.keras.applications.resnet.ResNet50(
            include_top=True,
            weights=None,
            input_tensor=None,
            input_shape=[32, 32, 3],
            pooling=None,
            classes=10
        )
        # Initiate model parameters dictionary <param_name, param>
        self.model_weights = {
            layer.name:[torch.from_numpy(p) for p in layer.get_weights()] for layer in self.model.layers
        }

if __name__ == "__main__":
    aggregator = Customized_Aggregator(args)
    aggregator.run()