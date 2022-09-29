import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import 'image_processing.dart';

Future<File> getFileProcessed() async {
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Directory? tempDir = await pp.getExternalStorageDirectory();
  tempDir ??= await pp.getApplicationDocumentsDirectory();

  final dirPath = '${tempDir.path}/media';
  await Directory(dirPath).create(recursive: true);
  final filePath = p.join(dirPath, '${timestamp()}.jpeg');
  return File(filePath);
}

Future<File> getCompressFile(File file, int quality) async {
  final imageProcessed = await getFileProcessed();

  ReceivePort receivePort = ReceivePort();
  ReceivePort resultPort = ReceivePort();

  await Isolate.spawn(ImageProcessing.compressImage, receivePort.sendPort);
  SendPort sendPort = await receivePort.first;
  sendPort.send([
    file,
    quality,
    resultPort.sendPort,
  ]);

  var imageBytes = (await resultPort.first) as List<int>;

  await file.delete(recursive: true);
  return await imageProcessed.writeAsBytes(
    imageBytes,
    flush: true,
  );
}

// Future<File> getWatermarkFile(File file, BaseWatermark mark) async {
//   final imageProcessed = await getFileProcessed();

//   ReceivePort receivePort = ReceivePort();
//   ReceivePort resultPort = ReceivePort();

//   if (mark) {
//     await Isolate.spawn(ImageProcessing.textStamp, receivePort.sendPort);
//   }

//   if (mark is ImageWatermark) {
//     await Isolate.spawn(ImageProcessing.imageStamp, receivePort.sendPort);
//   }

//   SendPort sendPort = await receivePort.first;
//   sendPort.send([
//     file,
//     mark,
//     resultPort.sendPort,
//   ]);

//   var imageBytes = (await resultPort.first) as List<int>;

//   await file.delete(recursive: true);
//   return await imageProcessed.writeAsBytes(
//     imageBytes,
//     flush: true,
//   );
// }

Future<File> getFlippedFile(File file, Flip flipMode) async {
  final imageProcessed = await getFileProcessed();

  ReceivePort receivePort = ReceivePort();
  ReceivePort resultPort = ReceivePort();

  await Isolate.spawn(ImageProcessing.flipImage, receivePort.sendPort);
  SendPort sendPort = await receivePort.first;
  sendPort.send([
    file,
    flipMode,
    resultPort.sendPort,
  ]);

  var imageBytes = (await resultPort.first) as List<int>;

  await file.delete(recursive: true);
  return await imageProcessed.writeAsBytes(
    imageBytes,
    flush: true,
  );
}

Future<File> getFileFromAssets(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final baseDir = (await pp.getTemporaryDirectory()).path;
  final fileName = assetPath.split("/").last;

  final filePath = p.join(baseDir, fileName);
  final file = File(filePath);

  final dataBytes = byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

  await file.writeAsBytes(dataBytes);
  return file;
}
