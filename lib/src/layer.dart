import 'package:extended_math/extended_math.dart';

import 'memory/short_memory.dart';
import 'neuron/base/neuron_base.dart';
import 'neuron/input_neuron.dart';
import 'neuron/neuron.dart';

/// Class that represent layer of neural network
class Layer<T extends NeuronBase> {
  /// Create [Layer] with given [_neurons]
  Layer(this._neurons);

  /// Creates empty layer
  Layer.empty() : this(<T>[]);

  /// Creates layer from neuron [count]
  ///
  /// [connects] is ignored if [inputLayer] is `true`.
  factory Layer.construct(int count, int connects, {bool inputLayer = false}) {
    final layer = Layer<NeuronBase>.empty();
    for (var i = 1; i <= count; i++) {
      layer.insert(inputLayer ? InputNeuron() : Neuron(connects));
    }
    return layer;
  }

  /// Contains all neurons of this layer
  List<T> _neurons;

  /// Inserts [neuron] in this layer
  ///
  /// Inserts [neuron] in [position] if it is specified,
  /// otherwise add [neuron] to end of this layer.
  /// [position] is in range from 1 to end inclusively.
  void insert(T neuron, {int position}) {
    position != null
        ? _neurons.insert(position - 1, neuron)
        : _neurons.add(neuron);
  }

  /// Removes neuron at specified [position]
  ///
  /// [position] is in range from 1 to end inclusively.
  T removeAt(int position) => _neurons.removeAt(position - 1);

  /// Gets neuron at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  T neuronAt(int position) => _neurons[position - 1];

  /// Gets all output neuron's values from this layer
  List<double> produce([List<List<Object>> weights]) {
    final out = <double>[];

    for (var i = 1; i <= _neurons.length; i++) {
      if (weights != null && weights.isNotEmpty) {
        final convertedWeights =
            weights[i - 1].map((v) => double.parse(v.toString())).toList();
        neuronAt(i).weights.setAll(0, convertedWeights);
      }
      out.add(neuronAt(i).out);
    }

    return out;
  }

  /// Accept [input] and pass it to [_neurons]
  ///
  /// If [inputLayer] is true, values of [input] are set to corresponding _neurons,
  /// otherwise all _neurons gets the same whole [input].
  void accept(List<double> input, {bool inputLayer = false}) {
    if (inputLayer) {
      for (var i = 1; i <= _neurons.length; i++) {
        neuronAt(i).inputs = <double>[input[i - 1]];
      }
    } else {
      for (var neuron in _neurons) {
        neuron.inputs = input;
      }
    }
  }

  /// Correct weights of _neurons according to [errors] and returns new errors for previous layer
  Vector propagate(Vector errors, double learningRate) {
    final partialErrors = <Vector>[];
    final layerData = <List<double>>[];

    for (var i = 1; i <= _neurons.length; i++) {
      final n = neuronAt(i);
      if (n is Neuron) {
        partialErrors.add(n.correctWeights(errors.itemAt(i), learningRate));
        layerData.add(n.weights);
      }
    }

    ShortMemory().list = layerData;
    ShortMemory().memorize();
    final result = partialErrors.reduce((f, s) => f + s);

    return result;
  }
}
