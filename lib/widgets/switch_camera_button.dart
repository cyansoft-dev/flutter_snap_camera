import 'package:flutter/material.dart';

import 'rotation_icon_widget.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({Key? key, this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double turns = 0.0;

    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 50,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 200),
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
