import 'package:egreenbin_interact/pages/camera_page/camera_page.dart';
import 'package:egreenbin_interact/pages/camera_page/controller/scan_controller.dart';
import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:egreenbin_interact/widgets/app_button.dart';
import 'package:egreenbin_interact/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingPage extends StatelessWidget {
  final ScanController controller = Get.find();
  WaitingPage({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.bgImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: height - 100,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
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
                Column(
                  children: [
                    const Header(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            "PLEASE THROW TRASH INTO THE RECYCLE BIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.brown,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            Assets.waitingArrow,
                            height: 150,
                          ),
                          Image.asset(
                            Assets.waitingTrash,
                            height: 200,
                          ),
                          TextButton(
                              onPressed: () {
                                controller.isTakeImage = true;
                                Get.to(CameraScreen());
                              },
                              child: Text("click"))
                        ],
                      ),
                    ),
                  ],
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
    );
  }
}
