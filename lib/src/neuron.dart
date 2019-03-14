import 'dart:math';

import 'package:extended_math/extended_math.dart';

/// Model of neuron
class Neuron {
  /// Create [Neuron] with specified [inputs] data
  ///
  /// [connects] tells which number of neurons of the upper layer is
  /// associated with this neuron.
  /// [activationFn] specifies which function are used for activation:
  ///
  ///     1. step
  ///     2. sigmoid (default)
  ///     3. tanh
  ///     4. relu
  ///     5. srelu (smooth relu or softplus)
  ///     6. lrelu (leaky relu)
  ///     7. prelu (parametric relu)
  ///     8. rrelu (randomized relu)
  ///     9. elu (exponential linear units)
  ///
  /// Only this values are allowed.
  ///
  /// [momentum] describe step of gradient descent (default 1).
  ///
  /// [bias] is limit of neuron's choice. Used only in `step` function.
  ///
  /// [hyperparameter] used in `PReLU`, `RReLU` and `ELU`.
  /// For `RReLU` it is a random number sampled from a uniform distribution
  /// `𝑈(𝑙, u)`, for `PReLU` it is a random value and for `ELU` it is
  /// random value that is equal or greater than zero.
  ///
  /// [isInput] flag whether this [Neuron] is input [Neuron].
  /// If [isInput] is `true`, [connects] must have value `0`
  /// (input neurons don't have previous layer, so don't have
  /// previous connections).
  Neuron(int connects,
      {this.inputs,
      double momentum,
      String activationFn,
      double bias,
      List<double> weights,
      double hyperparameter,
      this.isInput = false})
      : connects = connects == 0 ? 1 : connects {
    if (isInput) {
      this.weights.add(1);
    } else {
      final limit = 1 / sqrt(this.connects);
      weights != null
          ? this.weights.addAll(weights)
          : this.weights.addAll(NumbersGenerator()
              .doubleIterableSync(from: -limit, to: limit)
              .take(connects));
    }

    _momentum = momentum ?? 1;
    _activationFn = activationFn;
    _bias = bias;
    _hyperparameter = hyperparameter;
  }

  /// Weights of input values
  final List<double> weights = <double>[];

  /// Field that contain input values
  List<double> inputs;

  /// Connects that have this neuron
  int connects;

  /// Flags whether this neuron is input neuron or is not
  bool isInput;

  /// The degree of momentum of the `sigmoid` and `tanh` functions
  double _momentum;

  /// Bias of `step` activation function
  double _bias;

  /// Hyperparameter for `PReLU`, `RReLU` and `ELU` functions
  double _hyperparameter;

  /// Type of function that used for normalization neuron's output
  String _activationFn;

  /// Output value of this neuron
  double get out => isInput ? inputs[0] : _activate();

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

  /// Gets weighted sum
  double get _net => Vector(inputs).dot(Vector(weights));

  /// Activation function of neuron
  double _activate() {
    switch (_activationFn) {
      case 'step':
        return _net >= _bias ? 1 : 0;
      case 'tanh':
        return (pow(e, 2 * _net / _momentum) - 1) /
            (pow(e, 2 * _net / _momentum) + 1);
      case 'relu':
        return max(0, _net);
      case 'srelu':
        return log(1 + exp(_net));
      case 'lrelu':
        return _net > 0 ? _net : 0.01 * _net;
      case 'prelu':
        return _net > 0 ? _net : _hyperparameter * _net;
      case 'rrelu':
        return max(_net, _hyperparameter * _net);
      case 'elu':
        if (_hyperparameter < 0) {
          throw ArgumentError.value(_hyperparameter, '_hyperparameter',
              'Hyperparameter a must be equal or greater than zero!');
        }
        return _net > 0 ? _net : _hyperparameter * (exp(_net) - 1);
      default:
        return 1 / (1 + pow(e, -_momentum * _net));
    }
  }
}
