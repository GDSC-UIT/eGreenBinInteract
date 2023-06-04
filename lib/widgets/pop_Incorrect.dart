import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:flutter/material.dart';

class PopupInCorrect extends StatelessWidget {
  const PopupInCorrect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 50,
        right: 50,
        top: 200,
        bottom: 250,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.red,
          width: 5,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Text(
            "INCORRECT!",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.red,
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          Image.asset(Assets.wrongImg),
          Text(
            "LET TRY AGAIN!",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.grey,
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
