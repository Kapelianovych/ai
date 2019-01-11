import 'package:extended_math/extended_math.dart';

import 'base/neuron_base.dart';

/// Implementation of neuron
class Neuron extends NeuronBase {
  /// Create [Neuron] with specified [inputs]
  ///
  /// [connects] tells which number of neurons of the upper layer is associated with this neuron.
  /// [activationFn] specifies which function are used for activation:
  ///
  ///     1. step
  ///     2. sigmoid (default)
  ///     3. tanh
  ///
  /// Only this values are allowed.
  /// [bias] is limit of neuron's choice. Used only in `step` function.
  Neuron(int connects,
      {List<double> inputs,
      double steepness,
      String activationFn,
      double bias,
      List<double> weights})
      : super(connects,
            inputs: inputs,
            steepness: steepness,
            activationFn: activationFn,
            bias: bias,
            weights: weights);

  /// Corrects weights of this neuron according to [error] and
  /// returns `parts` of [error] according to each `weight`
  Vector correctWeights(double error, double learningRate) {
    final parts = <double>[];

    for (var i = 0; i < weights.length; i++) {
      parts.add(error * weights[i]);
      weights[i] -= learningRate * -error * out * (1 - out) * inputs[i];
    }

    return Vector(parts);
  }
}
