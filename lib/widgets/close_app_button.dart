import 'package:flutter/material.dart';

import 'glass_container.dart';
import 'rotation_icon_widget.dart';

class CloseAppButton extends StatelessWidget {
  const CloseAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const SizedBox.square(
        dimension: 36,
        child: GlassContainer(
          child: RotationIcon(
            Icons.close_rounded,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
