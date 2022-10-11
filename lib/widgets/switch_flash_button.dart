import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/widgets/rotation_icon_widget.dart';

import 'glass_container.dart';

class SwitchFlashButton extends StatelessWidget {
  const SwitchFlashButton({
    Key? key,
    required this.flashMode,
    this.onPressed,
  }) : super(key: key);
  final ValueNotifier<FlashMode> flashMode;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 50,
          child: GlassContainer(
            padding: const EdgeInsets.all(5),
            child: ValueListenableBuilder<FlashMode>(
              valueListenable: flashMode,
              builder: (context, value, child) {
                IconData icon;
                switch (value) {
                  case FlashMode.off:
                    icon = Icons.flash_off;
                    break;
                  case FlashMode.auto:
                    icon = Icons.flash_auto;
                    break;
                  case FlashMode.always:
                    icon = Icons.flash_on;
                    break;
                  case FlashMode.torch:
                    icon = Icons.light_mode_rounded;
                    break;
                }
                return RotationIcon(icon, size: 24, color: Colors.white);
              },
            ),
          ),
        ),
      ),
    );
  }
}
