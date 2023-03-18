import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(Assets.flowerImg),
          const Text(
            "eGreenBin",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Unbuntu",
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Image.asset(Assets.flowerImg),
        ],
      ),
    );
  }
}
