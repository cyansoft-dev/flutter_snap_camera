import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/constants/enum.dart';
import 'package:flutter_snap_camera/widgets/glass_container.dart';

import 'rotation_icon_widget.dart';

class SwitchCameraButton extends StatefulWidget {
  const SwitchCameraButton({
    Key? key,
    this.onPressed,
    required this.sensor,
  }) : super(key: key);
  final ValueNotifier<CameraSensor> sensor;
  final VoidCallback? onPressed;

  @override
  State<SwitchCameraButton> createState() => _SwitchCameraButtonState();
}

class _SwitchCameraButtonState extends State<SwitchCameraButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox.square(
        dimension: 50,
        child: GlassContainer(
          padding: const EdgeInsets.all(5),
          child: ValueListenableBuilder<CameraSensor>(
            valueListenable: widget.sensor,
            builder: (context, value, child) => AnimatedRotation(
              turns: value == CameraSensor.back ? 0.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: const RotationIcon(
                Icons.cached_outlined,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
