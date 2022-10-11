import 'package:flutter/material.dart';

import 'glass_container.dart';

class ImageCaptureButton extends StatelessWidget {
  const ImageCaptureButton({
    super.key,
    this.width = 65,
    this.onPressed,
  });
  final double? width;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        child: GestureDetector(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: width,
            child: GlassContainer(
              padding: const EdgeInsets.all(5),
              border: Border.all(width: 3, color: Colors.white),
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
}
