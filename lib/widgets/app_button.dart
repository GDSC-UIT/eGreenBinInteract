import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final String image;

  const AppButton(
      {super.key,
      required this.image,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
        // do something when the button is tapped
      },
      child: Container(
        height: 88,
        width: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(image),
        ),
      ),
    );
  }
}
