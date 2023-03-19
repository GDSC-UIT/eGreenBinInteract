import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TwoCircle extends StatelessWidget {
  const TwoCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [
      Positioned(
        bottom: 0,
        right: 15,
        child: Circle(
          color: Color(0xFF99BF6F),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Circle(
          color: Color(0xFFFFAC63),
        ),
      ),
    ]);
  }
}

class Circle extends StatelessWidget {
  final Color color;
  const Circle({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white, width: 2),
        color: color,
      ),
    );
  }
}
