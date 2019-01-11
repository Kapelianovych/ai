import 'dart:math';

import 'package:extended_math/extended_math.dart';

/// Model of neuron
abstract class NeuronBase {
  /// Create [NeuronBase] with specified [inputs]
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
  NeuronBase(this.connects,
      {this.inputs,
      double steepness,
      String activationFn,
      double bias,
      List<double> weights}) {
    if (weights != null) {
      this.weights.addAll(weights);
    } else {
      final limit = 1 / sqrt(connects);
      this.weights.addAll(NumbersGenerator()
          .doubleIterableSync(connects, from: -limit, to: limit));
    }

    _steepness = steepness ?? 1;
    _activationFn = activationFn;
    _bias = bias;
  }

  /// Weights of input values
  final List<double> weights = <double>[];

  /// Field that contain input values
  List<double> inputs;

  /// Connects that have this neuron
  int connects;

  /// The degree of steepness of the `sigmoid` and `tanh` functions
  double _steepness;

  /// Bias of `step` activation function
  double _bias;

  /// Type of function that used for normalization neuron's output
  String _activationFn;

  /// Output value of this neuron
  double get out => _activate();

  /// Gets weighted sum
  double get _net => Vector(inputs).dotProduct(Vector(weights));

  /// Activation function of neuron
  double _activate() {
    switch (_activationFn) {
      case 'step':
        if (_net >= _bias) {
          return 1;
        } else {
          return 0;
        }
        break;
      case 'tanh':
        return (pow(e, 2 * _net / _steepness) - 1) /
            (pow(e, 2 * _net / _steepness) + 1);
      default:
        return 1 / (1 + pow(e, -_steepness * _net));
    }
  }
}
