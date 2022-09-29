import 'type_def.dart';

class SnapCameraConfig {
  final bool? enableAudio;
  final bool? enableAspectRatio;
  final int? quality;
  final OnCapture? onCapture;

  SnapCameraConfig({
    this.enableAudio,
    this.enableAspectRatio,
    this.onCapture,
    this.quality,
  });
}
