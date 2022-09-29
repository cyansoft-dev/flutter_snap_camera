import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

///
class CameraPreviewWidget extends StatelessWidget {
  final Size? size;

  final Widget? child;

  final bool fitted;

  final BoxConstraints constraints;

  final CameraController controller;

  const CameraPreviewWidget(
    this.controller, {
    super.key,
    this.size = const Size(1920, 1080),
    required this.constraints,
    this.child,
    this.fitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return fitted
            ? buildFittedBox(orientation, constraints)
            : buildFull(context, orientation, constraints);
      },
    );
  }

  Widget buildFull(BuildContext context, Orientation orientation,
      BoxConstraints constraints) {
    final double ratio = size!.height / size!.width;
    return Container(
      color: Colors.black,
      child: Transform.scale(
        scale: _calculateScale(constraints, ratio, orientation),
        child: AspectRatio(
          aspectRatio: ratio,
          child: SizedBox(
            height: orientation == Orientation.portrait
                ? constraints.maxHeight
                : constraints.maxWidth,
            width: orientation == Orientation.portrait
                ? constraints.maxWidth
                : constraints.maxHeight,
            child: CameraPreview(controller, child: child),
          ),
        ),
      ),
    );
  }

  Widget buildFittedBox(Orientation orientation, BoxConstraints constraints) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: SizedBox(
        height:
            orientation == Orientation.portrait ? size!.height : size!.width,
        width: orientation == Orientation.portrait ? size!.width : size!.height,
        child: Center(
          child: AspectRatio(
            aspectRatio: size!.height / size!.width,
            child: SizedBox(
              height: orientation == Orientation.portrait
                  ? constraints.maxHeight
                  : constraints.maxWidth,
              width: orientation == Orientation.portrait
                  ? constraints.maxWidth
                  : constraints.maxHeight,
              child: CameraPreview(controller, child: child),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateScale(
      BoxConstraints constraints, double ratio, Orientation orientation) {
    final aspectRatio = constraints.maxWidth / constraints.maxHeight;
    var scale = ratio / aspectRatio;
    if (ratio < aspectRatio) {
      scale = 1 / scale;
    }

    return scale;
  }
}
