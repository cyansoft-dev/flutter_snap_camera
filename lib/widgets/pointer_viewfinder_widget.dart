import 'package:flutter/material.dart';

class PointerViewFinder extends StatelessWidget {
  const PointerViewFinder({
    super.key,
    required this.minExposureOffset,
    required this.maxExposureOffset,
  });
  final double minExposureOffset;
  final double maxExposureOffset;
  @override
  Widget build(BuildContext context) {
    double value = 0;
    return StatefulBuilder(
      builder: (context, setState) => IgnorePointer(
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  )),
              child: Center(
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            // Slider(
            //     min: minExposureOffset,
            //     max: maxExposureOffset,
            //     value: value,
            //     activeColor: Colors.white,
            //     inactiveColor: Colors.white24,
            //     onChanged: (result) {
            //       setState(() => value = result);
            //     })
          ],
        ),
      ),
    );
  }
}
