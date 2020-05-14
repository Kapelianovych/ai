import 'dart:io';

import 'package:extended_math/extended_math.dart';
import 'package:image/image.dart';

import '../utils/images.dart';

/// Class that represent the convolutional neural network (CNN)
///
/// **Do not use it in production**
class CNN {
  CNN(this.input, this.kernel);

  Matrix kernel;

  TensorBase input;

  File createImageFromConvolutionMatrix(Image originalImage, Matrix imageRGB) {
    final newImage = Image.fromBytes(originalImage.width, originalImage.height,
        imageRGB.toList().map((v) => v.toInt()).toList(), format: Format.rgb);
    final file = File('assets/new-image.png')
      ..writeAsBytesSync(newImage.getBytes());
    return file;
  }

  int _fixOutOfRangeRGBValues(num value) {
    var newValue = value;
    if (value < 0.0) {
      newValue = -value;
    }
    if (value > 255) {
      newValue = 255;
    }
    return newValue;
  }

  File detectEdges() {
    final decodedImage =
        decodeImage(File('assets/images/5.png').readAsBytesSync());
    final image = transformImageToTensor(decodedImage);
    final convolvedPixels = convolution(image, decodedImage);
    return createImageFromConvolutionMatrix(decodedImage, convolvedPixels);
  }

  Matrix convolution(Tensor3 tensoredImage, Image image) {
    final redConv = convolutionType2(
        tensoredImage.matrixAt(1), image.height, image.width, 1);
    final greenConv = convolutionType2(
        tensoredImage.matrixAt(2), image.height, image.width, 1);
    final blueConv = convolutionType2(
        tensoredImage.matrixAt(3), image.height, image.width, 1);
    final finalConv = TensorBase.generate(redConv.shape, (_) => 0).toMatrix();
//sum up all convolution outputs
    for (var i = 1; i <= finalConv.rows; i++) {
      for (var j = 1; j <= finalConv.columns; j++) {
        finalConv.setItem(
            i,
            j,
            redConv.itemAt(i, j) +
                greenConv.itemAt(i, j) +
                blueConv.itemAt(i, j));
      }
    }
    return finalConv;
  }

  /// Takes an image (grey-levels) and a kernel and a position,
  /// applies the convolution at that position and returns the
  /// new pixel value
  double _singlePixelConvolution(Matrix input, int x, int y) {
    var output = .0;
    for (var i = 1; i <= kernel.columns; ++i) {
      for (var j = 1; j <= kernel.rows; ++j) {
        output += input.itemAt(x + i, y + j) * kernel.itemAt(i, j);
      }
    }
    return output;
  }

  /// Takes a 2D array of grey-levels and a kernel and applies the convolution
  /// over the area of the image specified by width and height
  Matrix _convolution2D(Matrix input, int width, int height) {
    final smallWidth = width - kernel.columns + 1;
    final smallHeight = height - kernel.rows + 1;
    final output = Matrix.generate(smallHeight, smallWidth);
    for (var i = 1; i <= output.columns; ++i) {
      for (var j = 1; j <= output.rows; ++j) {
        output.setItem(i, j, _singlePixelConvolution(input, i, j));
      }
    }
    return output;
  }

  /// Takes a 2D array of grey-levels and a kernel, applies the convolution
  /// over the area of the image specified by width and height and returns
  /// a part of the final image
  Matrix convolution2DPadded(Matrix input, int width, int height) {
    final top = kernel.rows ~/ 2;
    final left = kernel.columns ~/ 2;

    final small = _convolution2D(input, width, height);
    final large = Matrix.generate(width, height);

    for (var j = 1; j <= small.rows; ++j) {
      for (var i = 1; i <= small.columns; ++i) {
        large.setItem(i + left, j + top, small.itemAt(i, j));
      }
    }
    return large;
  }

  /// Applies the convolution2DPadded  algorithm to the input array as many as
  /// iteration
  Matrix convolutionType2(Matrix input, int width, int height, int iterations) {
    var newInput = input.copy();
    Matrix output;

    for (var i = 0; i < iterations; ++i) {
      output = convolution2DPadded(newInput, width, height);
      newInput = output.copy();
    }
    return output;
  }
}
