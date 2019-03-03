import 'package:extended_math/extended_math.dart';

/// Class that shows in console error during training
class Visualization {
  /// Factory constructor that return single [Visualization] per multiple calls
  factory Visualization() => _instance;

  /// Create instance of [Visualization]
  Visualization._init(this._dataLength);

  /// Instance of [Visualization]
  static Visualization _instance;

  /// Data's length of visualization
  final int _dataLength;

  /// Save errors for one epoch
  final List<List<num>> _storage = <List<num>>[];

  /// Calculates MSE and send error to terminal
  void console(Vector errors) {
    if (_storage.length == _dataLength) {
      final mean = CentralTendency(Matrix(_storage));
      print('Error - ${Double(mean.quadratic()).preciseTo(4)}');
      _storage.clear();
    } else {
      _storage.add(errors.map((v) => v.abs()).data);
    }
  }

  /// Initialize [Visualization] instance
  static void init(int dataLength) {
    _instance ??= Visualization._init(dataLength);
  }
}
