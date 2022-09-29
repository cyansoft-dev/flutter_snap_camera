import 'package:flutter/material.dart';

class ZoomLevel extends StatelessWidget {
  const ZoomLevel({
    super.key,
    required this.zoomLevel,
  });
  final double zoomLevel;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: zoomLevel > 1.0 ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Container(
          width: 65,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            '${zoomLevel.toStringAsFixed(1)}x',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
