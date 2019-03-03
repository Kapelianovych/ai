import 'package:extended_math/extended_math.dart';

/// Class that represent the convolutional neural network (CNN)
///
/// **Do not use it in production**
class CNN {
  CNN(this.input, this.kernel);

  TensorBase kernel;

  TensorBase input;

  TensorBase convolution() {
    final inputTmp = input.toVector();
    final kernelTmp = kernel.toVector();
    final newInput = Vector.generate(inputTmp.data.length, (_) => 0);
    final padZero = kernelTmp.data.length ~/ 2;

    for (var i = 0; i < padZero; i++) {
      inputTmp.insert(0);
    }
    for (var i = 0; i < padZero; i++) {
      //inputTmp.insert(0, inputTmp.data.length + 1);
    }

    for (var i = 1; i <= inputTmp.data.length; i++) {
      if (i <= inputTmp.data.length - kernelTmp.data.length + 1) {
        //newInput.insert(i, inputTmp.subvector(i, i + kernelTmp.data.length - 1).dot(kernelTmp));
      }
    }
    return newInput;
  }
}
