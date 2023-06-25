import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_test/home/layout.dart';

class CustomPaintPage extends StatelessWidget {
  const CustomPaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '커스텀페인트',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 300,
            height: 450,
            color: Colors.amber,
            child: CustomPaint(
              painter: CustomPaintExample(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPaintExample extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(102, 87, 255, 1);

    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 330)
      ..quadraticBezierTo(size.width, size.height, 280, size.height)
      // ..quadraticBezierTo(280, size.height, 270, size.height - 10)
      ..lineTo(0, 380)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
