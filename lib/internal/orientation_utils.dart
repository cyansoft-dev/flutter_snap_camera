import 'dart:math';

import 'package:flutter/services.dart';

class OrientationUtils {
  static DeviceOrientation convertRadianToOrientation(double radians) {
    late DeviceOrientation orientation;
    if (radians == -pi / 2) {
      orientation = DeviceOrientation.landscapeLeft;
    } else if (radians == pi / 2) {
      orientation = DeviceOrientation.landscapeRight;
    } else if (radians == 0.0) {
      orientation = DeviceOrientation.portraitUp;
    } else if (radians == pi) {
      orientation = DeviceOrientation.portraitDown;
    }
    return orientation;
  }

  static double convertOrientationToRadian(DeviceOrientation orientation) {
    late double radians;
    switch (orientation) {
      case DeviceOrientation.landscapeLeft:
        radians = -pi / 2;
        break;
      case DeviceOrientation.landscapeRight:
        radians = pi / 2;
        break;
      case DeviceOrientation.portraitUp:
        radians = 0.0;
        break;
      case DeviceOrientation.portraitDown:
        radians = pi;
        break;
      default:
    }
    return radians;
  }

  static bool isOnPortraitMode(DeviceOrientation orientation) {
    return (orientation == DeviceOrientation.portraitUp ||
        orientation == DeviceOrientation.portraitDown);
  }
}
