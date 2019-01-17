import 'base/memory_base.dart';
import 'long_memory.dart';

/// Class that imitates humans short memory
class ShortMemory extends MemoryBase {
  /// Gets sort memory instance as singleton
  factory ShortMemory() => _shortMemory;

  /// Instantiate [ShortMemory]
  ShortMemory._init();

  /// Holds short memory instance
  static final ShortMemory _shortMemory = ShortMemory._init();

  /// Holds any numbers (current layer)
  num number;

  /// Store temporary weights of layer.
  List<List<double>> _list;

  /// Gets copy of [_list]
  List<List<double>> get list => _list.map((l) => l.toList()).toList();

  /// Copy [list] to internal storage
  set list(List<List<double>> list) =>
      _list = list.map((l) => l.toList()).toList();

  @override
  void memorize() => LongMemory().accept(number, _list);

  @override
  void forget() {
    number = null;
    _list = null;
  }
}
