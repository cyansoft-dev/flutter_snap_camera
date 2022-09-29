import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snap_camera/constants/config.dart';
import 'package:flutter_snap_camera/constants/enum.dart';
import 'package:flutter_snap_camera/internal/file_processing.dart';
import 'package:flutter_snap_camera/widgets/close_app_button.dart';
import 'package:flutter_snap_camera/widgets/pointer_viewfinder_widget.dart';
import 'package:flutter_snap_camera/widgets/switch_camera_button.dart';
import 'package:flutter_snap_camera/widgets/switch_flash_button.dart';
import 'package:image/image.dart' as img;
import '../internal/method.dart';
import '../widgets/image_capture_button.dart';
import '../pages/camera_view.dart';
import '../widgets/initialize_wrapper.dart';
import '../widgets/rotation_icon_widget.dart';
import '../widgets/zoom_level_widget.dart';

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? initController;

  /// Available cameras
  List<CameraDescription>? cameras;

  /// The maximum available value for zooming.
  double maxAvailableZoom = 1.0;

  /// The minimum available value for zooming.
  double minAvailableZoom = 1.0;

  /// The maximum available value for zooming.
  double maxAvailableExposureOffset = 0.0;

  /// The minimum available value for zooming.
  double minAvailableExposureOffset = 0.0;

  double currentExposure = 0.0;

  /// Counting pointers (number of user fingers on screen).
  int pointers = 0;

  double currentScale = 1.0;

  double baseScale = 1.0;

  double x = 0.0;

  double y = 0.0;

  ValueNotifier<Ratio> ratio = ValueNotifier(Ratio.fullscreen);

  ValueNotifier<File?> imageCapture = ValueNotifier(null);

  ValueNotifier<FlashMode> flashMode = ValueNotifier(FlashMode.off);

  SnapCameraConfig? get cameraConfig => widget.config;

  bool showFocus = false;

  bool get enableAudio => cameraConfig?.enableAudio ?? true;

  bool get enableAspectRatio => cameraConfig?.enableAspectRatio ?? false;

  int? get quality => cameraConfig?.quality;

  int currentCameraIndex = 0;

  // CameraDescription get currentCamera => cameras.elementAt(currentCameraIndex);

  @override
  void initState() {
    super.initState();

    /// Hide system status bar automatically.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: <SystemUiOverlay>[]);

    ambiguate(WidgetsBinding.instance)?.addObserver(this);

    /// Initialize camera.
    initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? prevController = initController;
    if (prevController == null || !prevController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      prevController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      final currentCamera = cameras?.elementAt(currentCameraIndex);
      createNewCamera(currentCamera);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    ratio.dispose();
    flashMode.dispose();
    imageCapture.dispose();
    initController?.dispose();
    // currentZoom.dispose();
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: Colors.black,
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            ExcludeSemantics(
              child: ValueListenableBuilder<File?>(
                valueListenable: imageCapture,
                builder: (context, value, child) {
                  if (value != null) {
                    return Image.file(
                      value,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    );
                  }
                  return InitializeWrapper(
                    controller: initController,
                    builder: (CameraValue v, Widget? w) {
                      return buildCameraPreview(constraints);
                    },
                  );
                },
              ),
            ),
            buildForegroundBody(constraints),
          ],
        );
      },
    );
  }

  Widget buildCameraPreview(BoxConstraints constraints) {
    Widget preview = Listener(
      onPointerDown: (_) => pointers++,
      onPointerUp: (_) => pointers--,
      child: InitializeWrapper(
        controller: initController,
        builder: (value, child) => CameraPreview(
          initController!,
          child: GestureDetector(
            onScaleStart: handleScaleStart,
            onScaleUpdate: handleScaleUpdate,
            onTapDown: (details) => onViewFinderTap(details, constraints),
          ),
        ),
      ),
    );

    return RepaintBoundary(child: preview);
  }

  Widget buildForegroundBody(BoxConstraints constraints) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          if (showFocus)
            Positioned(
              top: y - 25,
              left: x - 25,
              child: PointerViewFinder(
                minExposureOffset: minAvailableExposureOffset,
                maxExposureOffset: maxAvailableExposureOffset,
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Semantics(
              sortKey: const OrdinalSortKey(0),
              hidden: initController == null,
              child: buildSettingActions(),
            ),
          ),
          Positioned(
            bottom: 175,
            left: 0,
            right: 0,
            child: Semantics(
              sortKey: const OrdinalSortKey(1),
              child: ZoomLevel(
                zoomLevel: currentScale,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Semantics(
              sortKey: const OrdinalSortKey(2),
              hidden: initController == null,
              child: buildCaptureActions(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingActions() {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          ValueListenableBuilder<File?>(
              valueListenable: imageCapture,
              builder: (context, image, child) => AnimatedOpacity(
                  opacity: image == null ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const CloseAppButton())),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildCaptureActions() {
    return SizedBox(
      height: 150,
      // color: Colors.black54,
      child: ValueListenableBuilder<File?>(
        valueListenable: imageCapture,
        builder: (context, image, child) {
          final double padding = image == null ? 50 : 75;
          return Center(
            child: AnimatedPadding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: 20,
              ),
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: 100,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: image == null ? listCaptureAction() : listImageAction(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listImageAction() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              final image = imageCapture.value;
              image?.deleteSync(recursive: true);
              imageCapture.value = null;
            },
            child: SizedBox.square(
              dimension: 50,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                child: const RotationIcon(
                  Icons.close_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox.square(dimension: 10),
          GestureDetector(
            onTap: () async {
              File? image = imageCapture.value;
              if (quality != null) {
                getCompressFile(image!, quality!)
                    .then((value) => Navigator.pop(context, value));
                return;
              }

              Navigator.pop(context, image);
            },
            child: SizedBox.square(
              dimension: 50,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                child: const RotationIcon(
                  Icons.check_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]);
  }

  Widget listCaptureAction() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SwitchFlashButton(
            flashMode: flashMode,
            onPressed: handleSwitchFlashMode,
          ),
          ImageCaptureButton(
            controller: initController,
            onCapture: (image) async {
              if (currentCameraIndex == 1) {
                if (image != null) {
                  image = await getFlippedFile(image, img.Flip.horizontal);
                }
              }
              imageCapture.value = image;
            },
          ),
          SwitchCameraButton(
            onPressed: () {
              createNewCamera(nextCamera);
            },
          ),
        ]);
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    createNewCamera(cameras![0]);
  }

  Future<void> createNewCamera([CameraDescription? cameraDescription]) async {
    CameraController? prevController = initController;
    if (prevController != null) {
      initController = null;
      await prevController.dispose();
    }

    final int index;
    if (prevController == null) {
      index = 0;
      currentCameraIndex = index;
    } else {
      index = currentCameraIndex;
    }

    final newController = CameraController(
      cameraDescription!,
      ResolutionPreset.max,
      enableAudio: enableAudio,
    );

    newController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await newController.initialize();

      await Future.wait(
        <Future<void>>[
          newController.getMinZoomLevel().then((value) {
            minAvailableZoom = value;
          }),
          newController.getMaxZoomLevel().then((value) {
            maxAvailableZoom = value;
          }),
          newController.getMinExposureOffset().then((double value) {
            minAvailableExposureOffset = value;
          }),
          newController.getMaxExposureOffset().then((double value) {
            maxAvailableExposureOffset = value;
          })
        ],
        eagerError: true,
      );

      flashMode.value = newController.value.flashMode;
    } catch (e, s) {
      debugPrint("error : $e, stacktrace : $s");
    }

    if (mounted) {
      setState(() {
        initController = newController;
      });
    }
  }

  Future<void> zoom(double scale) async {
    if (maxAvailableZoom == minAvailableZoom) {
      return;
    }

    final double zoom = (baseScale * scale).clamp(
      minAvailableZoom,
      maxAvailableZoom,
    );
    if (zoom == currentScale) {
      return;
    }
    try {
      await initController?.setZoomLevel(zoom);
      setState(() {
        currentScale = zoom;
      });
    } catch (e, s) {
      debugPrint("error : $e, stacktrace : $s");
    }
  }

  Future<void> onViewFinderTap(
      TapDownDetails details, BoxConstraints constraints) async {
    if (initController == null) {
      return;
    }
    final CameraController cameraController = initController!;
    setState(() => showFocus = true);

    x = details.localPosition.dx;
    y = details.localPosition.dy;

    double xp = x / constraints.maxWidth;
    double yp = y / constraints.maxHeight;

    Offset offset = Offset(xp, yp);

    cameraController.setExposurePoint(offset);
    handleFocus(cameraController, offset);
  }

  Future<void> handleFocus(CameraController controller, Offset offset) async {
    controller.setFocusPoint(offset);
    await controller.setFocusMode(FocusMode.locked);
    Future.delayed(const Duration(milliseconds: 1000)).whenComplete(
      () {
        setState(() => showFocus = false);
      },
    );
  }

  /// Handle when button flash on tap
  Future<void> handleSwitchFlashMode() async {
    final FlashMode newFlashMode;
    switch (initController!.value.flashMode) {
      case FlashMode.off:
        newFlashMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newFlashMode = FlashMode.always;
        break;
      case FlashMode.always:
        newFlashMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newFlashMode = FlashMode.off;
        break;
    }
    try {
      await initController!.setFlashMode(newFlashMode);
      flashMode.value = newFlashMode;
    } catch (e, s) {
      debugPrint("error : $e, stacktrace : $s");
    }
  }

  /// Handle when the scale gesture start.
  void handleScaleStart(ScaleStartDetails details) {
    baseScale = currentScale;
  }

  /// Handle when the double tap scale details is updating.
  void handleScaleUpdate(ScaleUpdateDetails details) {
    // When there are not exactly two fingers on screen don't scale
    if (pointers != 2) {
      return;
    }
    zoom(details.scale);
  }

  CameraDescription get nextCamera {
    currentCameraIndex++;
    if (currentCameraIndex == cameras!.length) {
      currentCameraIndex = 0;
      return cameras![0];
    } else {
      return cameras![currentCameraIndex];
    }
  }
}
