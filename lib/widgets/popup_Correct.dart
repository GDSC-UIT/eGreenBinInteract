import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class PopupCorrect extends StatefulWidget {
  const PopupCorrect({super.key});

  @override
  State<PopupCorrect> createState() => _PopupCorrectState();
}

class _PopupCorrectState extends State<PopupCorrect> {
  late ConfettiController _confettiControllerLeft =
      ConfettiController(duration: const Duration(seconds: 10));

  late ConfettiController _confettiControllerRight =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void dispose() {
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiControllerLeft.play();
    _confettiControllerRight.play();
  }

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
          color: AppColors.subPrimary,
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
            "CORRECT!",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.subPrimary,
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          Image.asset(Assets.correctImg),
          Text(
            "GOOD JOB!",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.grey,
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _confettiControllerLeft,
              blastDirection: -pi / 3,
              emissionFrequency: 0.01,
              numberOfParticles: 10,
              maximumSize: const Size(20, 10),
              maxBlastForce: 40,
              minBlastForce: 30,
              gravity: 0.1,
              shouldLoop: true,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _confettiControllerRight,
              blastDirection: -3 * pi / 4,
              emissionFrequency: 0.01,
              numberOfParticles: 10,
              maximumSize: const Size(20, 10),
              maxBlastForce: 40,
              minBlastForce: 30,
              gravity: 0.1,
              shouldLoop: true,
            ),
          ),
        ],
      ),
    );
  }
}
