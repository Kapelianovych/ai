import 'package:extended_math/extended_math.dart';

import 'memory/short_memory.dart';
import 'neuron.dart';

/// Class that represent layer of neural network
class Layer {
  /// Create [Layer] with given [_neurons]
  Layer(this._neurons);

  /// Creates empty layer
  Layer.empty() : this(<Neuron>[]);

  /// Creates layer from neuron [count]
  ///
  /// All parameters exept [count] is ignored if [inputLayer] is `true`.
  ///
  /// [activationFn] - function that is used in neurons for activation.
  ///
  /// [momentum] describe step of gradient descent (default 1).
  ///
  /// [bias] is limit of neuron's choice. Used only in `step` function.
  ///
  /// [hyperparameter] used in `PReLU`, `RReLU` and `ELU`. For `RReLU`
  /// it is a random number sampled from a uniform distribution 
  /// `𝑈(𝑙, u)`, for `PReLU` it is a random value and for
  /// `ELU` it is random value that is equal or greater than zero.
  factory Layer.construct(int count, int connects,
      {bool inputLayer = false,
      String activationFn,
      double momentum,
      double bias,
      double hyperparameter}) {
    final layer = Layer.empty();
    for (var i = 1; i <= count; i++) {
      layer.insert(Neuron(connects,
          activationFn: activationFn,
          momentum: momentum,
          bias: bias,
          hyperparameter: hyperparameter,
          isInput: inputLayer));
    }
    return layer;
  }

  /// Contains all neurons of this layer
  List<Neuron> _neurons;

  /// Inserts [neuron] in this layer
  ///
  /// Inserts [neuron] in [position] if it is specified,
  /// otherwise add [neuron] to end of this layer.
  /// [position] is in range from 1 to end inclusively.
  void insert(Neuron neuron, {int position}) {
    position != null
        ? _neurons.insert(position - 1, neuron)
        : _neurons.add(neuron);
  }

  /// Removes neuron at specified [position]
  ///
  /// [position] is in range from 1 to end inclusively.
  Neuron removeAt(int position) => _neurons.removeAt(position - 1);

  /// Gets neuron at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  Neuron neuronAt(int position) => _neurons[position - 1];

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
  /// If [inputLayer] is true, values of [input] are set to 
  /// corresponding _neurons,
  /// otherwise all _neurons gets the same whole [input].
  void accept(List<double> input, {bool inputLayer = false}) {
    if (inputLayer) {
      for (var i = 1; i <= _neurons.length; i++) {
        neuronAt(i).inputs = <double>[input[i - 1]];
      }
    } else {
      for (final neuron in _neurons) {
        neuron.inputs = input;
      }
    }
  }

  /// Correct weights of _neurons according to [errors] and returns 
  /// new errors for previous layer
  Vector propagate(Vector errors, double learningRate) {
    final partialErrors = <Vector>[];
    final layerData = <List<double>>[];

    for (var i = 1; i <= _neurons.length; i++) {
      final n = neuronAt(i);
      if (!n.isInput) {
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
