import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class InitializeWrapper extends StatelessWidget {
  const InitializeWrapper({super.key, this.controller, required this.builder});
  final CameraController? controller;
  final Widget Function(CameraValue value, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<CameraValue>(
      valueListenable: controller!,
      builder: (_, CameraValue value, Widget? child) {
        if (value.isInitialized) {
          return builder(value, child);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
