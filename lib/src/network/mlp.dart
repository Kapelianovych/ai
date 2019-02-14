import 'package:extended_math/extended_math.dart';
import 'package:meta/meta.dart';

import '../entities/structure.dart';
import '../layer.dart';
import '../memory/long_memory.dart';
import '../memory/short_memory.dart';
import '../visualization/visualization.dart';
import 'network_base.dart';

/// Class that represent the multilayer perseptron (MLP)
class MLP extends NetworkBase {
  /// Create [MLP] with given [_layers] and optionally [activationFn], [momentum], [bias], [hyperparameter]
  MLP(this._layers,
      {String activationFn,
      double momentum,
      double bias,
      double hyperparameter})
      : super(
            activationFn: activationFn,
            momentum: momentum,
            bias: bias,
            hyperparameter: hyperparameter);

  /// Create instance of [MLP] from given [Structure]
  MLP.from(Structure structure)
      : super(
            activationFn: structure.activation,
            momentum: structure.momentum,
            bias: structure.bias,
            hyperparameter: structure.hyperparameter) {
    final mlp = structure.forMLP();

    final layers = <Layer>[];
    var prevLayerCount = mlp.input;

    layers.add(Layer.construct(mlp.input, 0, inputLayer: true));

    if (mlp.hiddens != null && mlp.hiddens.isNotEmpty) {
      for (var count in mlp.hiddens) {
        layers.add(Layer.construct(count, prevLayerCount,
            activationFn: activationFn,
            momentum: momentum,
            bias: bias,
            hyperparameter: hyperparameter));
        prevLayerCount = count;
      }
    }

    layers.add(Layer.construct(mlp.output, prevLayerCount,
        activationFn: activationFn,
        momentum: momentum,
        bias: bias,
        hyperparameter: hyperparameter));

    _layers = layers;
  }

  /// Contains [_layers] of this network
  List<Layer> _layers;

  @override
  Layer layerAt(int position) => _layers[position - 1];

  /// Predicts result with given [input]
  List<double> predict(List<double> input) {
    List<double> result;
    final weights = LongMemory().remember();

    layerAt(1).accept(input, inputLayer: true);

    for (var i = 1; i <= _layers.length; i++) {
      List<List<Object>> layerWeights;

      if (i >= 2 && weights != null) {
        layerWeights = List<List<Object>>.from(weights['$i']);
      }

      result = layerAt(i).produce(layerWeights);

      if (i < _layers.length) {
        layerAt(i + 1).accept(result);
      }
    }

    return result;
  }

  /// Trains the [MLP] using `backpropagation` algorithm
  void _backPropagation(
      List<double> input, List<double> expected, double learningRate) {
    final result = predict(input);

    var errors = Vector(expected) - Vector(result);

    // Executed if visualize is true
    Visualization()?.console(errors);

    for (var i = _layers.length; i >= 2; i--) {
      ShortMemory().number = i;
      errors = layerAt(i).propagate(errors, learningRate);
    }
  }

  /// Train this perseptron
  ///
  /// If [visualize] is `true` MSE is calculated and sends to console.
  ///
  /// [learningRate] is a hyper-parameter that controls how much we are adjusting the weights
  /// of our network with respect the loss gradient.
  void train(
      {@required List<List<double>> input,
      @required List<List<double>> expected,
      @required double learningRate,
      @required int epoch,
      bool visualize = false}) {
    for (var i = 0; i < epoch; i++) {
      for (var j = 0; j < input.length; j++) {
        if (visualize) {
          // Initialize logger
          Visualization.init(input.length);
        }

        _backPropagation(input[j], expected[j], learningRate);
      }
    }

    LongMemory().memorize();
  }
}
