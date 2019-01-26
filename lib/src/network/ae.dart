import 'package:meta/meta.dart';
import 'package:extended_math/extended_math.dart';

import '../entities/structure.dart';
import '../layer.dart';
import '../memory/long_memory.dart';
import '../memory/short_memory.dart';
import '../neuron/base/neuron_base.dart';

/// Class that represent the autoencoder (AE)
class AE {
  /// Create [AE] with given [_layers]
  AE(this._layers);

  /// Create instance of [AE] with path to network's structure specified by `structure.json` file
  ///
  /// If [path] to your `structure.json` isn't provided, it is implies that file is in `resources`
  /// directory in the root of library.
  ///
  /// Format of `structure.json` file:
  /// ```json
  /// {
  ///   "type": "AE",
  ///   "input": 15, // count of `InputNeuron`s
  ///   "hiddens": [3], // array length shows count of hidden `Layer`s and values are count
  ///       // of `Neuron`s of each layer for encoded and decoded parts
  ///   "decoded": 3 // count of decoded data `Neuron`s
  // }
  /// ```
  AE.fromStructure([String path]) {
    final structure = Structure(path).forAE();

    final layers = <Layer<NeuronBase>>[];
    var prevLayerCount = structure.input;

    layers
        .add(Layer<NeuronBase>.construct(structure.input, 0, inputLayer: true));

    if (structure.hiddens != null && structure.hiddens.isNotEmpty) {
      for (var count in structure.hiddens) {
        layers.add(Layer<NeuronBase>.construct(count, prevLayerCount));
        prevLayerCount = count;
      }
    }

    layers.add(Layer<NeuronBase>.construct(structure.encoded, prevLayerCount));
    prevLayerCount = structure.encoded;

    if (structure.hiddens != null && structure.hiddens.isNotEmpty) {
      for (var count in structure.hiddens.reversed.toList()) {
        layers.add(Layer<NeuronBase>.construct(count, prevLayerCount));
        prevLayerCount = count;
      }
    }

    layers.add(Layer<NeuronBase>.construct(structure.input, prevLayerCount));

    _layers = layers;
  }

  /// Contains [_layers] of this network
  List<Layer<NeuronBase>> _layers;

  /// Encoded input data
  List<double> _encodedData;

  /// Gets layer at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  Layer<NeuronBase> layerAt(int position) => _layers[position - 1];

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

    // print(errors.dotProduct(errors));

    for (var i = _layers.length; i >= 2; i--) {
      ShortMemory().number = i;
      errors = layerAt(i).propagate(errors, learningRate);
    }
  }

  /// Train this perseptron
  void train(
      {@required List<List<double>> input,
      @required double learningRate,
      @required int epoch}) {
    for (var i = 0; i < epoch; i++) {
      for (var j = 0; j < input.length; j++) {
        _backPropagation(input[j], learningRate);
      }
    }

    LongMemory().memorize();
  }
}
