import 'package:extended_math/extended_math.dart';
import 'package:meta/meta.dart';

import '../layer.dart';
import '../memory/long_memory.dart';
import '../memory/short_memory.dart';
import '../neuron/base/neuron_base.dart';
import 'base/network_base.dart';

/// Class that represent the whole neural network
class MultilayerPerceptron extends NetworkBase {
  /// Create [MultilayerPerceptron] with given [layers]
  MultilayerPerceptron(List<Layer<NeuronBase>> layers) : super(layers);

  /// Creates empty multilayer perceptron
  MultilayerPerceptron.empty() : super.empty();

  /// Trains the [MultilayerPerceptron] using `backpropagation` algorithm
  void _backPropagation(
      List<double> input, List<double> expected, double learningRate) {
    final result = predict(input);

    var errors = Vector(expected) - Vector(result);
    for (var i = layers.length; i >= 2; i--) {
      ShortMemory().number = i;
      errors = layerAt(i).propagate(errors, learningRate);
    }
  }

  /// Train this perseptron
  void train(
      {@required List<List<double>> input,
      @required List<double> expected,
      @required double learningRate,
      @required int epoch}) {
    for (var i = 0; i < epoch; i++) {
      for (var j = 0; j < input.length; j++) {
        _backPropagation(input[j], <double>[expected[j]], learningRate);
      }
    }

    LongMemory().memorize();
  }
}
