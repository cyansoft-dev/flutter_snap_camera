import 'package:flutter/material.dart';

Future<void> showMessage(
  BuildContext context,
  String message, {
  AnimationController? controller,
}) {
  return showModalBottomSheet(
    transitionAnimationController: controller,
    elevation: 2,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: context,
    builder: (builder) {
      return SizedBox(
        height: 250,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      fixedSize: const Size(300, 48),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
