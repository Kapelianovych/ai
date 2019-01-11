import '../../layer.dart';
import '../../memory/long_memory.dart';
import '../../neuron/base/neuron_base.dart';

/// Base class for all type of neural networks
abstract class NetworkBase {
  /// Create `network` with given [layers]
  NetworkBase(this.layers);

  /// Creates empty neural network
  NetworkBase.empty();

  /// Contains [layers] of this network
  List<Layer<NeuronBase>> layers;

  /// Gets layer at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  Layer<NeuronBase> layerAt(int position) => layers[position - 1];

  /// Predicts result with given [input]
  List<double> predict(List<double> input) {
    List<double> result;
    final weights = LongMemory().remember();

    layerAt(1).accept(input, inputLayer: true);

    for (var i = 1; i <= layers.length; i++) {
      List<List<Object>> layerWeights;

      if (i >= 2 && weights != null) {
        layerWeights = List<List<Object>>.from(weights['$i']);
      }

      result = layerAt(i).produce(layerWeights);

      if (i != layers.length) {
        layerAt(i + 1).accept(result);
      }
    }

    return result;
  }
}
