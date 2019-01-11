import 'dart:convert';
import 'dart:io';

import '../utils/system.dart';

/// Class that retain network's data
class LongMemory {
  /// Gets instance of [LongMemory] as singleton
  factory LongMemory() => _longMemory;
  /// Creates [LongMemory] instance
  LongMemory._init();

  /// Holds instance of [LongMemory]
  static final LongMemory _longMemory = LongMemory._init();
  /// Data that will be retained
  final Map<String, List<List<double>>> _data = <String, List<List<double>>>{};
  /// File [_data] to be written in
  final File _file = createFile('resources/knowledge.json');

  /// Add [data] to memory corresponding to layer
  void accept(int layerNumber, List<List<double>> data) {
    _data['$layerNumber'] = data;
  }

  /// Saves network's data
  void retain() => _file.writeAsStringSync(jsonEncode(_data));

  /// Returns newtwork's data from file
  /// 
  /// If file doesn't exist returns `null`.
  Map<String, Object> remember() {
    if (_file.existsSync()) {
      final encodedData = _file.readAsStringSync();
      return jsonDecode(encodedData);
    }
    return null;
  }

  /// Delete network's data
  void forget() {
    _data.clear();
    if (_file.existsSync()) {
      _file.deleteSync();
    }
  }
}