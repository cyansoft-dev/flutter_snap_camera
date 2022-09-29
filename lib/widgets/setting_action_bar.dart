import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_camera/constants/enum.dart';

import 'rotation_icon_widget.dart';

class SettingActionBar extends StatefulWidget {
  const SettingActionBar(
    this.cameraController, {
    super.key,
    this.enableAspectRatio,
    this.ratio,
  });

  final CameraController? cameraController;
  final bool? enableAspectRatio;
  final ValueNotifier<Ratio>? ratio;

  @override
  State<SettingActionBar> createState() => _SettingActionBarState();
}

class _SettingActionBarState extends State<SettingActionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _animation;

  final ValueNotifier<ActionBarStatus> _barStatus =
      ValueNotifier(ActionBarStatus.none);

  bool _isExpand = false;

  @override
  void initState() {
    super.initState();
    prepareAnimation();
  }

  @override
  void dispose() {
    _barStatus.dispose();
    _expandController.dispose();
    super.dispose();
  }

  prepareAnimation() {
    _expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _expandController, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.black54,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: flashIcon(),
                onPressed: () {
                  _isExpand = !_isExpand;
                  _barStatus.value = ActionBarStatus.showFlashMode;
                  checkExpand();
                },
              ),
              const Spacer(),

              /// check if enable aspect ratio is true
              if (widget.enableAspectRatio != null && widget.enableAspectRatio!)
                IconButton(
                  icon: aspectRatioIcon(),
                  onPressed: () {
                    _isExpand = !_isExpand;
                    _barStatus.value = ActionBarStatus.showAspectRatio;
                    checkExpand();
                  },
                ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            height: 60,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.black26,
            child: settingActionBarChild(),
          ),
        )
      ],
    );
  }

  Widget settingActionBarChild() {
    return ValueListenableBuilder<ActionBarStatus>(
        valueListenable: _barStatus,
        builder: (context, status, child) {
          if (status == ActionBarStatus.showFlashMode) {
            return flashModeAction();
          }

          if (status == ActionBarStatus.showAspectRatio) {
            return aspectRationAction();
          }

          return const SizedBox.shrink();
        });
  }

  Widget aspectRationAction() {
    return ValueListenableBuilder<Ratio>(
      valueListenable: widget.ratio!,
      builder: (context, ratio, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.fullscreen,
                color: (ratio == Ratio.fullscreen)
                    ? const Color(0xff5dd39e)
                    : Colors.white,
              ),
              onPressed: () {
                widget.ratio?.value = Ratio.fullscreen;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.aspect_ratio,
                color: (ratio == Ratio.medium)
                    ? const Color(0xff5dd39e)
                    : Colors.white,
              ),
              onPressed: () {
                widget.ratio?.value = Ratio.medium;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.crop_square,
                color: (ratio == Ratio.portrait)
                    ? const Color(0xff5dd39e)
                    : Colors.white,
              ),
              onPressed: () {
                widget.ratio?.value = Ratio.portrait;
              },
            ),
          ]),
    );
  }

  Widget flashModeAction() {
    final mode = widget.cameraController?.value.flashMode;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: RotationIcon(
              Icons.flash_on,
              color: (mode == FlashMode.always)
                  ? const Color(0xff5dd39e)
                  : Colors.white,
            ),
            onPressed: () {
              widget.cameraController?.setFlashMode(FlashMode.always);
            },
          ),
          IconButton(
            icon: RotationIcon(
              Icons.flash_off,
              color: (mode == FlashMode.off)
                  ? const Color(0xff5dd39e)
                  : Colors.white,
            ),
            onPressed: () {
              widget.cameraController?.setFlashMode(FlashMode.off);
            },
          ),
          IconButton(
            icon: RotationIcon(
              Icons.flash_auto,
              color: (mode == FlashMode.auto)
                  ? const Color(0xff5dd39e)
                  : Colors.white,
            ),
            onPressed: () {
              widget.cameraController?.setFlashMode(FlashMode.auto);
            },
          ),
          IconButton(
            icon: RotationIcon(
              Icons.light_mode_rounded,
              color: (mode == FlashMode.torch)
                  ? const Color(0xff5dd39e)
                  : Colors.white,
            ),
            onPressed: () {
              widget.cameraController?.setFlashMode(FlashMode.torch);
            },
          ),
        ]);
  }

  Widget aspectRatioIcon() {
    return ValueListenableBuilder(
      valueListenable: widget.ratio!,
      builder: (context, value, child) {
        switch (widget.ratio!.value) {
          case Ratio.fullscreen:
            return const Icon(
              Icons.fullscreen,
              color: Colors.white,
            );

          case Ratio.medium:
            return const Icon(
              Icons.aspect_ratio,
              color: Colors.white,
            );

          default:
            return const Icon(
              Icons.crop_square,
              color: Colors.white,
            );
        }
      },
    );
  }

  Widget flashIcon() {
    IconData icon;
    switch (widget.cameraController!.value.flashMode) {
      case FlashMode.off:
        icon = Icons.flash_off;
        break;
      case FlashMode.auto:
        icon = Icons.flash_auto;
        break;
      case FlashMode.always:
        icon = Icons.flash_on;
        break;
      case FlashMode.torch:
        icon = Icons.light_mode_rounded;
        break;
    }

    return RotationIcon(
      icon,
      color: Colors.white,
    );
  }

  void checkExpand() {
    if (_isExpand) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }
}
