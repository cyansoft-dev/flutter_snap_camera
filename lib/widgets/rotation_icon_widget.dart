import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class RotationIcon extends StatefulWidget {
  const RotationIcon(this.iconData, {super.key, this.size, this.color});
  final IconData iconData;
  final double? size;
  final Color? color;

  @override
  State<RotationIcon> createState() => _RotationIconState();
}

class _RotationIconState extends State<RotationIcon> {
  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientationReader(
        useSensor: true, // --> [2]
        builder: (ctx) {
          final orientation = NativeDeviceOrientationReader.orientation(ctx);
          double turns = 0.0;
          switch (orientation) {
            case NativeDeviceOrientation.portraitUp:
              turns = 0.0;
              break;
            case NativeDeviceOrientation.portraitDown:
              turns = 0.5;
              break;
            case NativeDeviceOrientation.landscapeLeft:
              turns = 0.25;
              break;
            case NativeDeviceOrientation.landscapeRight:
              turns = -0.25;
              break;
            case NativeDeviceOrientation.unknown:
              turns = 0.0;
              break;
          }
          // --> [3]
          return AnimatedRotation(
            turns: turns,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              widget.iconData,
              size: widget.size,
              color: widget.color,
            ),
          );
        });
  }
}
