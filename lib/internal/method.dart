import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

T? ambiguate<T>(T value) => value;

Future<Offset?> alignToOffset(Uint8List image, Alignment? alignment) async {
  final img = await decodeImageFromList(image);

  final width = img.width;
  final height = img.height;

  final x = alignment?.x ?? 0;
  final y = alignment?.y ?? 0;

  final dx = x * (width / 2) + (width / 2);
  final dy = y * (height / 2) + (height / 2);

  return Offset(dx, dy);
}
