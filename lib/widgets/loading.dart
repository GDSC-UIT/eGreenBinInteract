import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Màn hình trắng
          Container(
            color: Colors.white,
          ),
          // Biểu tượng loading
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xff99BF6F),
            ),
          ),
        ],
      ),
    );
  }
}
