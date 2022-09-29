import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/constants/config.dart';

import 'package:flutter_snap_camera/flutter_snap_camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snap Camera Example")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () async {
            final data = await CameraView.snapImage(
              context,
              cameraConfig: SnapCameraConfig(
                quality: 50,
              ),
            );
            debugPrint("$data");
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera),
                SizedBox(width: 7),
                Text("Take Picture"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
