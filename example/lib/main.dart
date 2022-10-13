import 'dart:io';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<File?> image = ValueNotifier(null);

  @override
  void dispose() {
    image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snap Camera Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: 400,
                width: 250,
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  child: ValueListenableBuilder<File?>(
                    valueListenable: image,
                    builder: (context, value, child) {
                      if (value == null) {
                        return const SizedBox.shrink();
                      }

                      return Image.file(value);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () async {
                final config = SnapCameraConfig(
                  quality: 50,
                  watermark: TextWatermark(
                    "Test watermark",
                    offset: const Offset(10, 10),
                  ),
                );

                final data = await CameraView.snapImage(
                  context,
                  cameraConfig: config,
                );
                debugPrint("$data");
                image.value = data;
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
          ],
        ),
      ),
    );
  }
}
