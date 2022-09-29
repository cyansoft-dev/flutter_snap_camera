import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/constants/config.dart';
import '../states/camera_view_state.dart';

class CameraView extends StatefulWidget {
  const CameraView._({Key? key, this.config}) : super(key: key);

  final SnapCameraConfig? config;

  static Future<File?> snapImage(
    BuildContext context, {
    bool useRootNavigator = true,
    SnapCameraConfig? cameraConfig,
    MaterialPageRoute<File?> Function(Widget cameraView)? pageRouteBuilder,
  }) {
    Widget cameraView = CameraView._(
      config: cameraConfig,
    );

    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<File?>(
      pageRouteBuilder?.call(cameraView) ??
          MaterialPageRoute<File?>(builder: (_) => cameraView),
    );
  }

  @override
  State<CameraView> createState() => CameraViewState();
}
