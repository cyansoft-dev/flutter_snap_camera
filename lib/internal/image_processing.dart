import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;

class ImageProcessing {
  static Future<void> flipImage(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);
    List msg = (await receivePort.first) as List;

    File file = msg[0];
    img.Flip flipMode = msg[1];
    SendPort replyPort = msg[2];

    // decoding original image
    final imageBytes = await file.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    img.Image flippedImage = img.flip(
      originalImage!,
      flipMode,
    );

    final encodeBytes = img.encodeJpg(flippedImage);
    replyPort.send(encodeBytes);
  }

  // static Future<void> textStamp(SendPort sendPort) async {
  //   ReceivePort receivePort = ReceivePort();

  //   sendPort.send(receivePort.sendPort);
  //   List msg = (await receivePort.first) as List;

  //   File file = msg[0];
  //   TextWatermark mark = msg[1];
  //   SendPort replyPort = msg[2];

  //   /// decoding original image
  //   final imageBytes = await file.readAsBytes();
  //   img.Image? originalImage = img.decodeImage(imageBytes);

  //   img.Image stampedImage = img.drawString(
  //     originalImage!,
  //     img.arial_14,
  //     mark.posX,
  //     mark.posY,
  //     mark.text,
  //   );

  //   final encodeBytes = img.encodeJpg(stampedImage);
  //   replyPort.send(encodeBytes);
  // }

  // static Future<void> imageStamp(SendPort sendPort) async {
  //   ReceivePort receivePort = ReceivePort();

  //   sendPort.send(receivePort.sendPort);
  //   List msg = (await receivePort.first) as List;

  //   File file = msg[0];
  //   Watermark mark = msg[1];
  //   SendPort replyPort = msg[2];

  //   // decoding original image
  //   final imageBytes = await file.readAsBytes();
  //   img.Image? originalImage = img.decodeImage(imageBytes);

  //   // decoding watermark image
  //   final watermarkBytes = await mark.value.readAsBytes();
  //   img.Image? watermarkImage = img.decodeImage(watermarkBytes);

  //   img.Image stampedImage = img.copyInto(
  //     originalImage!,
  //     watermarkImage!,
  //     dstX: mark.posX,
  //     dstY: mark.posY,
  //   );

  //   final encodeBytes = img.encodeJpg(stampedImage);
  //   replyPort.send(encodeBytes);
  // }

  static Future<void> compressImage(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);
    List msg = (await receivePort.first) as List;

    File file = msg[0];
    int quality = msg[1];
    SendPort replyPort = msg[2];

    // decoding original image
    final imageBytes = await file.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    // set reduce size
    int targetWidth = (originalImage!.width / 100 * quality).floor();
    int targetHeight = (originalImage.height / 100 * quality).floor();

    // resize image
    img.Image resizeImage = img.copyResize(
      originalImage,
      width: targetWidth,
      height: targetHeight,
    );

    final encodeBytes = img.encodeJpg(resizeImage, quality: quality);
    replyPort.send(encodeBytes);
  }
}
