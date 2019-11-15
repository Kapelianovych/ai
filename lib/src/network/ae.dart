import 'package:meta/meta.dart';
import 'package:extended_math/extended_math.dart';

import '../entities/structure.dart';
import '../layer.dart';
import '../memory/long_memory.dart';
import '../memory/short_memory.dart';
import '../visualization/visualization.dart';
import 'network_base.dart';

/// Class that represent the autoencoder (AE)
class AE extends NetworkBase {
  /// Create [AE] with given [_layers] and optionally [activationFn],
  /// [momentum], [bias], [hyperparameter]
  AE(this._layers,
      {String activationFn,
      double momentum,
      double bias,
      double hyperparameter})
      : super(
            activationFn: activationFn,
            momentum: momentum,
            bias: bias,
            hyperparameter: hyperparameter);

  /// Create instance of [AE] from given [Structure]
  AE.from(Structure structure)
      : super(
            activationFn: structure.activation,
            momentum: structure.momentum,
            bias: structure.bias,
            hyperparameter: structure.hyperparameter) {
    final ae = structure.forAE();

    final layers = <Layer>[];
    var prevLayerCount = ae.input;

    layers.add(Layer.construct(ae.input, 0, inputLayer: true));

    if (ae.hiddens != null && ae.hiddens.isNotEmpty) {
      for (final count in ae.hiddens) {
        layers.add(Layer.construct(count, prevLayerCount,
            activationFn: activationFn,
            momentum: momentum,
            bias: bias,
            hyperparameter: hyperparameter));
        prevLayerCount = count;
      }
    }

    layers.add(Layer.construct(ae.encoded, prevLayerCount,
        activationFn: activationFn,
        momentum: momentum,
        bias: bias,
        hyperparameter: hyperparameter));
    prevLayerCount = ae.encoded;

    if (ae.hiddens != null && ae.hiddens.isNotEmpty) {
      for (final count in ae.hiddens.reversed.toList()) {
        layers.add(Layer.construct(count, prevLayerCount,
            activationFn: activationFn,
            momentum: momentum,
            bias: bias,
            hyperparameter: hyperparameter));
        prevLayerCount = count;
      }
    }

    layers.add(Layer.construct(ae.input, prevLayerCount,
        activationFn: activationFn,
        momentum: momentum,
        bias: bias,
        hyperparameter: hyperparameter));

    _layers = layers;
  }

  /// Contains [_layers] of this network
  List<Layer> _layers;

  /// Encoded input data
  List<double> _encodedData;

  @override
  Layer layerAt(int position) => _layers[position - 1];

  /// Predicts encoded data with given [input]
  List<double> _predict(List<double> input) {
    List<double> result;
    final weights = LongMemory().remember();

    layerAt(1).accept(input, inputLayer: true);

    for (var i = 1; i <= _layers.length; i++) {
      List<List<Object>> layerWeights;

      if (i >= 2 && weights != null) {
        layerWeights = List<List<Object>>.from(weights['$i']);
      }

      result = layerAt(i).produce(layerWeights);

      if ((_layers.length - 1) ~/ 2 == i - 1) {
        _encodedData = result;
      }

      if (i < _layers.length) {
        layerAt(i + 1).accept(result);
      }
    }

    return result;
  }

  /// Encodes [input] data
  List<double> encode(List<double> input) {
    _predict(input);
    return _encodedData;
  }

  /// Trains the [AE] using `backpropagation` algorithm
  void _backPropagation(List<double> input, double learningRate) {
    final result = _predict(input);

    var errors = Vector(input) - Vector(result);

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
  void train(
      {@required List<List<double>> input,
      @required double learningRate,
      @required int epoch,
      bool visualize = false}) {
    for (var i = 0; i < epoch; i++) {
      for (var j = 0; j < input.length; j++) {
        if (visualize) {
          // Initialize logger
          Visualization.init(input.length);
        }

        _backPropagation(input[j], learningRate);
      }
    }

    LongMemory().memorize();
  }
}
