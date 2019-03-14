import 'package:extended_math/extended_math.dart';
import 'package:image/image.dart';

/// Transforms image to [Tensor3]
Tensor3 transformImageToTensor(Image image) {
    final width = image.width;
    final height = image.height;
    final imageList = image.getBytes().toList();

    final tensoredImage = Tensor3
      .generate(width, height, 3, (_) => 0);

    for (var i = 1; i <= height; i++) {
      for (var j = 1; j <= width; j++) {
        tensoredImage
          ..setItem(height, width, 1, imageList.removeAt(1))
          ..setItem(height, width, 2, imageList.removeAt(1))
          ..setItem(height, width, 3, imageList.removeAt(1));
        imageList.removeAt(1); // removes alpha byte
      }
    }
    return tensoredImage;
}