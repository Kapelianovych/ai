import 'package:extended_math/extended_math.dart';
import 'package:meta/meta.dart';

import '../entities/structure.dart';
import '../layer.dart';
import '../memory/long_memory.dart';
import '../memory/short_memory.dart';
import '../neuron/base/neuron_base.dart';
import '../neuron/input_neuron.dart';
import '../neuron/neuron.dart';

/// Class that represent the multilayer perseptron (MLP)
class MLP {
  /// Create instance of [MLP] with path to network's structure specified by `structure.json` file
  ///
  /// If [path] to your `structure.json` isn't provided, it is implies that file is in `resources`
  /// directory in the root of library.
  ///
  /// Format of `structure.json` file:
  /// ```json
  /// {
  ///   "type": "MLP",
  ///   "input": 15, // count of `InputNeuron`s
  ///   "hiddens": [3], // array length shows count of hidden `Layer`s and values are count of `Neuron`s of each layer
  ///   "output": 3 // count of output `Neuron`s
  // }
  /// ```
  MLP.fromStructure([String path]) {
    final structure = Structure(path).forMLP();

    final layers = <Layer<NeuronBase>>[];

    final inputLayer = <InputNeuron>[];
    final hiddenLayers = <List<Neuron>>[];
    final outputLayer = <Neuron>[];

    for (var i = 0; i < structure.input; i++) {
      inputLayer.add(InputNeuron());
    }
    layers.add(Layer<InputNeuron>(inputLayer));

    var prevLayerCount = inputLayer.length;
    for (var count in structure.hiddens) {
      final list = List<Neuron>.generate(count, (_) => Neuron(prevLayerCount));
      hiddenLayers.add(list);
      prevLayerCount = count;
    }
    layers.addAll(hiddenLayers.map((a) => Layer<Neuron>(a)));

    for (var i = 0; i < structure.output; i++) {
      outputLayer.add(Neuron(hiddenLayers[hiddenLayers.length - 1].length));
    }
    layers.add(Layer<Neuron>(outputLayer));

    _layers = layers;
  }

  /// Create [MLP] with given [_layers]
  MLP.withLayers(this._layers);

  /// Contains [_layers] of this network
  List<Layer<NeuronBase>> _layers;

  /// Gets layer at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  Layer<NeuronBase> layerAt(int position) => _layers[position - 1];

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
    for (var i = _layers.length; i >= 2; i--) {
      ShortMemory().number = i;
      errors = layerAt(i).propagate(errors, learningRate);
    }
  }

  /// Train this perseptron
  void train(
      {@required List<List<double>> input,
      @required List<List<double>> expected,
      @required double learningRate,
      @required int epoch}) {
    for (var i = 0; i < epoch; i++) {
      for (var j = 0; j < input.length; j++) {
        _backPropagation(input[j], expected[j], learningRate);
      }
    }

    LongMemory().memorize();
  }
}
