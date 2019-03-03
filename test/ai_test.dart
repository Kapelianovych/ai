import 'dart:io';

import 'package:ai/ai.dart';
import 'package:extended_math/extended_math.dart';

void main() {
  final k = Vector(<num>[0, 1, 0, 1, 2, 1, 0, 1, 0]);

  final c = CNN(k, k);
  //print(image.getBytes());
  print(c.convolution());
}
