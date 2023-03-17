import 'package:camera/camera.dart';
import 'package:egreenbin_interact/pages/camera_page/controller/scan_controller.dart';
import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraViewer extends GetView<ScanController> {
  const CameraViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(
      builder: (controller) {
        if (!controller.isInitialized) {
          return Container();
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brown, width: 5),
              ),
              child: AspectRatio(
                aspectRatio: 1 / 0.9,
                child: ClipRect(
                  child: Transform.scale(
                    scale: controller.cameraController.value.aspectRatio / 0.7,
                    child: Center(
                      child: CameraPreview(controller.cameraController),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
