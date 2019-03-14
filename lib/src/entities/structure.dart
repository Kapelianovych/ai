import 'dart:convert';
import 'dart:io';

import '../constants/constants.dart';
import 'ae_structure.dart';
import 'mlp_structure.dart';

/// Class that represent `structure.json` file
class Structure {
  /// Creates [Structure] instance
  ///
  /// If [path] to your `structure.json` isn't provided, it is 
  /// implies that file is in `resources`
  /// directory in the root of library.
  ///
  /// Format of `structure.json` file:
  /// ```json
  /// {
  ///   "type": "MLP",
  ///   "activation": "relu",
  ///   "input": 15,
  ///   "hiddens": [3],
  ///   "output": 3
  /// }
  /// ```
  ///
  /// Where `type` - type of network, `activation` - activation 
  /// functioan that is used in neurons,
  /// `input` - count of `InputNeuron`s, `hiddens` - array length shows
  /// count of hidden `Layer`s and values are count of `Neuron`s of 
  /// each layer, `output` - count of output `Neuron`s.
  Structure([String path])
      : structure = jsonDecode(File(path ?? structurePath).readAsStringSync());

  /// File that describe network's structure
  final Map<String, Object> structure;

  /// Type of the network for which `structure.json` is provided
  String get type => structure['type'] as String;

  /// Activation function for neurons of the notwork
  String get activation => structure['activation'] as String;

  /// The degree of momentum of the `sigmoid` and `tanh` functions
  double get momentum => structure['momentum'] as double;

  /// Bias of `step` activation function
  double get bias => structure['bias'] as double;

  /// Hyperparameter for `PReLU`, `RReLU` and `ELU` functions
  double get hyperparameter => structure['hyperparameter'] as double;

  /// Gets structure for MLP
  ///
  /// If [type] isn't `MLP` returns `null`.
  MlpStructure forMLP() =>
      type == 'MLP' ? MlpStructure.fromJson(structure) : null;

  /// Gets structure for MLP
  ///
  /// If [type] isn't `AE` returns `null`.
  AeStructure forAE() => type == 'AE' ? AeStructure.fromJson(structure) : null;

  @override
  String toString() => 'Structure for $type';
}
