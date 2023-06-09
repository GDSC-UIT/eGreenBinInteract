import 'package:audioplayers/audioplayers.dart';
import 'package:egreenbin_interact/pages/camera_page/controller/scan_controller.dart';
import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:egreenbin_interact/widgets/app_button.dart';
import 'package:egreenbin_interact/widgets/camera_viewer.dart';
import 'package:egreenbin_interact/widgets/got_faceLabel.dart';
import 'package:egreenbin_interact/widgets/header.dart';
import 'package:egreenbin_interact/widgets/loading.dart';
import 'package:egreenbin_interact/widgets/non_faceLabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  final ScanController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initCamera();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(
      (() => controller.isInitialized
          ? Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    height: height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.bgImg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 70),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Column(
                              children: [
                                const Header(),
                                const SizedBox(
                                  height: 18,
                                ),
                                Obx(
                                  () => !controller.isGotFace.value
                                      ? const NonFaceLabel()
                                      : const GotFaceLabel(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const CameraViewer(),
                                const SizedBox(
                                  height: 25,
                                ),
                                if (controller.trashLabel.value != "" &&
                                    controller.studentName.value != "")
                                  Column(
                                    children: [
                                      const Text(
                                        "Let's guess what kind of trash I am!",
                                        style: TextStyle(
                                          fontFamily: "ubuntu",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              AppButton(
                                                onPressed: () async {
                                                  controller.trashLabel.value ==
                                                          ""
                                                      ? () {
                                                          print(
                                                              "dont have trash label");
                                                        }
                                                      : controller.handleAction(
                                                          "inrecycle");
                                                  // controller.handleAction("inrecycle");
                                                },
                                                color: controller
                                                            .trashLabel.value !=
                                                        ""
                                                    ? AppColors.orange
                                                    : AppColors.orangeDisable,
                                                image: Assets.recycleImg,
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "NON-RECYCLE",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.orange,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              AppButton(
                                                onPressed: () async {
                                                  controller.trashLabel.value ==
                                                          ""
                                                      ? () {}
                                                      : controller.handleAction(
                                                          "recycle");
                                                  // controller.handleAction("recycle");
                                                },
                                                color: controller
                                                            .trashLabel.value !=
                                                        ""
                                                    ? AppColors.subPrimary
                                                    : AppColors
                                                        .subPrimaryDisable,
                                                image: Assets.recycleImg,
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "RECYCLE",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.subPrimary,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                TextButton(
                                  onPressed: () {
                                    controller.trashLabel.value = "cardboard";
                                    controller.isTakeImage = true;
                                  },
                                  child: Text("get trash"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.resetImage();
                                  },
                                  child: Text("reset"),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(Assets.binImg),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : LoadingScreen()),
    );
  }
}
