import 'package:audioplayers/audioplayers.dart';
import 'package:egreenbin_interact/pages/camera_page/controller/scan_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends GetView<ScanController> {
  CameraScreen({Key? key}) : super(key: key);

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(
      builder: (controller) {
        if (!controller.isInitialized) {
          return Container();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(),
          ),
        );
      },
    );
  }
}
