import 'dart:io';
import 'dart:ui';

abstract class Watermark {
  final Offset offset;
  Watermark(this.offset);
}

class TextWatermark extends Watermark {
  TextWatermark(this.label, {required Offset offset}) : super(offset);
  final String label;
}

class ImageWatermark extends Watermark {
  ImageWatermark(this.imageFile,
      {required Offset offset, this.size = Size.zero})
      : super(offset);
  final File imageFile;
  final Size size;
}
