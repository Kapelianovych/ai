import 'long_memory.dart';

/// Class that imitates humans short memory
class ShortMemory {
  /// Gets sort memory instance as singleton
  factory ShortMemory() => _shortMemory;
  /// Instantiate [ShortMemory]
  ShortMemory._init();

  /// Holds short memory instance
  static final ShortMemory _shortMemory = ShortMemory._init();
  /// Holds any numbers
  num number;
  List<List<double>> _list;
  /// Gets copy of [_list]
  List<List<double>> get list => _list.map((l) => l.toList()).toList();
  /// Copy [list] to internal storage
  set list(List<List<double>> list) => _list = list.map((l) => l.toList()).toList();

  /// Send data to long memory
  void memorize() {
    LongMemory().accept(number, _list);
    clear();
  }

  /// Clears data
  void clear() {
    number = null;
    _list = null;
  }
}