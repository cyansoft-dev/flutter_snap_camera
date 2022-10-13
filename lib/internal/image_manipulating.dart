import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/constants/watermark.dart';
import 'package:image_editor/image_editor.dart';

class ImageManipulating {
  static ImageManipulating? _instance;

  ImageManipulating._(this._quality);

  final int? _quality;

  int get quality => _quality ?? 100;

  factory ImageManipulating.init({int? quality}) =>
      _instance ?? ImageManipulating._(quality);

  Future<File?> compressImage(File image) async {
    final option = ImageEditorOption()
      ..outputFormat = OutputFormat.jpeg(quality);

    final result = await ImageEditor.editFileImageAndGetFile(
        file: image, imageEditorOption: option);

    return result;
  }

  Future<File?> flippedImage(File image, FlipOption flipOption) async {
    final option = ImageEditorOption()
      ..addOption(flipOption)
      ..outputFormat = OutputFormat.jpeg(quality);

    final result = await ImageEditor.editFileImageAndGetFile(
        file: image, imageEditorOption: option);

    return result;
  }

  Future<File?> addWatermark(File image, Watermark watermark) async {
    File? result;
    if (watermark is TextWatermark) {
      result = await _addText(image, watermark);
    }

    if (watermark is ImageWatermark) {
      result = await _mergeImage(image, watermark);
    }

    return result;
  }

  Future<File?> _addText(File image, TextWatermark watermark) async {
    // final alignment = watermark.alignment;
    // final imageBytes = image.readAsBytesSync();

    final offset = watermark.offset;
    // final offset = await alignToOffset(imageBytes, alignment);

    final textOption = AddTextOption()
      ..addText(EditorText(
          text: watermark.label, offset: offset, textColor: Colors.white));

    final option = ImageEditorOption()
      ..addOption(textOption)
      ..outputFormat = OutputFormat.jpeg(quality);

    final result = await ImageEditor.editFileImageAndGetFile(
        file: image, imageEditorOption: option);

    return result;
  }

  Future<File?> _mergeImage(File image, ImageWatermark watermark) async {
    final dst = await watermark.imageFile.readAsBytes();

    final offset = watermark.offset;
    // final offset = await alignToOffset(dst, alignment) ?? Offset.zero;

    final dx = offset.dx.toInt();
    final dy = offset.dy.toInt();

    final width = watermark.size.width.toInt();
    final height = watermark.size.height.toInt();

    final mixOption = MixImageOption(
        target: MemoryImageSource(dst),
        x: dx,
        y: dy,
        width: width,
        height: height);

    final option = ImageEditorOption()
      ..addOption(mixOption)
      ..outputFormat = OutputFormat.jpeg(quality);

    final result = await ImageEditor.editFileImageAndGetFile(
        file: image, imageEditorOption: option);

    return result;
  }
}
