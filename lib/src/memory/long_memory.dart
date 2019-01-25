import 'dart:convert';
import 'dart:io';

import '../constants/constants.dart';
import '../utils/system.dart';
import 'base/memory_base.dart';

/// Class that retain network's data
class LongMemory extends MemoryBase {
  /// Gets instance of [LongMemory] as singleton
  factory LongMemory() => _longMemory;

  /// Creates [LongMemory] instance
  LongMemory._init();

  /// Holds instance of [LongMemory]
  static final LongMemory _longMemory = LongMemory._init();

  /// Data that will be retained
  final Map<String, List<List<double>>> _data = <String, List<List<double>>>{};

  /// File [_data] to be written in
  final File _file = createFile(knowledgePath);

  /// Add [data] to memory corresponding to layer
  void accept(int layerNumber, List<List<double>> data) {
    _data['$layerNumber'] = data;
  }

  @override
  void memorize() => _file.writeAsStringSync(jsonEncode(_data));

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

  @override
  void forget() {
    _data.clear();
    if (_file.existsSync()) {
      _file.deleteSync();
    }
  }
}
