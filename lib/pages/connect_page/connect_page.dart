import 'package:egreenbin_interact/pages/camera_page/camera_page.dart';
import 'package:egreenbin_interact/pages/camera_page/controller/scan_controller.dart';
import 'package:egreenbin_interact/pages/waiting_page/waiting_page.dart';
import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:egreenbin_interact/widgets/app_button.dart';
import 'package:egreenbin_interact/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectPage extends StatelessWidget {
  ConnectPage({super.key});
  TextEditingController textController = TextEditingController();
  final ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
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
                              "Enter IP Address of IoT System",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            AppButton(
                              onPressed: () {
                                try {
                                  controller.connectEsp(textController.text);
                                  Get.off(CameraScreen());
                                } on FormatException catch (_, e) {
                                  Get.snackbar(
                                    "cannot connect try again",
                                    "$e",
                                    colorText: AppColors.red,
                                    backgroundColor: AppColors.lightGrey,
                                  );
                                }
                              },
                              color: AppColors.subPrimary,
                              text: "Connect",
                            )
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
      ),
    );
  }
}
