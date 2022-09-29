import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../constants/type_def.dart';

class ImageCaptureButton extends StatefulWidget {
  const ImageCaptureButton({
    super.key,
    this.controller,
    this.width = 65,
    this.onCapture,
  });
  final double? width;
  final CameraController? controller;
  final OnCapture? onCapture;

  @override
  State<ImageCaptureButton> createState() => _ImageCaptureButtonState();
}

class _ImageCaptureButtonState extends State<ImageCaptureButton> {
  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        hidden: widget.controller == null,
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox.square(
            dimension: widget.width,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30,
                border: Border.all(width: 3, color: Colors.white),
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTap() async {
    if (widget.controller!.value.isTakingPicture) {
      return;
    }

    widget.controller!.takePicture().then((value) {
      File? image = File(value.path);
      widget.onCapture?.call(image);
    });
  }
}
