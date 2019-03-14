import '../layer.dart';

/// Class that describe fundamentals of networks
abstract class NetworkBase {
  /// Initiate [activationFn], [momentum], [bias] and [hyperparameter]
  ///
  /// [activationFn] specifies which function are used for neuron activation:
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
  /// [hyperparameter] is used in `PReLU`, `RReLU` and `ELU`. For
  /// `RReLU` it is a random number sampled from a uniform distribution
  /// `𝑈(𝑙, u)`, for `PReLU` it is a random value and for
  /// `ELU` it is random value that is equal or greater than zero.
  NetworkBase(
      {this.activationFn, this.momentum, this.bias, this.hyperparameter});

  /// Name of the activation function that is used by neuron
  String activationFn;

  /// The degree of momentum of the `sigmoid` and `tanh` functions
  double momentum;

  /// Bias of `step` activation function
  double bias;

  /// Hyperparameter for `PReLU`, `RReLU` and `ELU` functions
  double hyperparameter;

  /// Gets layer at specified [position]
  ///
  /// [position] should be in range from 1 to end inclusively.
  Layer layerAt(int position);
}
