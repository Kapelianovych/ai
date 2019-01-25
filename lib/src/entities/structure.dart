import 'dart:convert';
import 'dart:io';

import '../constants/constants.dart';
import 'mlp_structure.dart';

/// Class that represent `structure.json` file
class Structure {
  /// Creates [Structure] instance
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
  Structure([String path])
      : structure = jsonDecode(File(path ?? structurePath).readAsStringSync());

  /// File that describe network's structure
  final Map<String, Object> structure;

  /// Type of the network for which `structure.json` is provided
  String get type => structure['type'] as String;

  /// Gets structure for MLP
  ///
  /// If [type] isn't `MLP` returns `null`.
  MlpStructure forMLP() =>
      type == 'MLP' ? MlpStructure.fromJson(structure) : null;

  @override
  String toString() => 'Structure for $type';
}
