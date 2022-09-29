import 'package:flutter/material.dart';

import 'rotation_icon_widget.dart';

class CloseAppButton extends StatelessWidget {
  const CloseAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: SizedBox.square(
        dimension: 36,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.black54,
            padding: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const RotationIcon(
            Icons.close_rounded,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
