import 'package:flutter_snap_camera/constants/watermark.dart';

import 'type_def.dart';

class SnapCameraConfig {
  final bool? enableAudio;
  final bool? enableAspectRatio;
  final int? quality;
  final OnCapture? onCapture;
  final Watermark? watermark;

  SnapCameraConfig({
    this.enableAudio,
    this.enableAspectRatio,
    this.onCapture,
    this.quality,
    this.watermark,
  });
}
