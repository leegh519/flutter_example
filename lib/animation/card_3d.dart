import 'dart:math';

import 'package:flutter/material.dart';

class Card3D extends StatefulWidget {
  const Card3D({super.key});

  @override
  State<Card3D> createState() => _Card3DState();
}

class _Card3DState extends State<Card3D> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      lowerBound: -1.2,
      upperBound: 1.2,
      value: 0,
    );

    super.initState();
  }

  double xPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('card'),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Transform(
            transform: Matrix4.identity()
              // ..setEntry(3, 0, 0.0002),
              // [ 1 0 0 x ]
              // [ 0 1 0 0 ]
              // [ 0 0 1 0 ]
              // [ 0 0 0 1 ]
              // ..setEntry(3, 1, 0.001),
              // [ 1 0 0 0 ]
              // [ 0 1 0 y ]
              // [ 0 0 1 0 ]
              // [ 0 0 0 1 ]
              ..setEntry(3, 2, 0.001)
              // [ 1 0 0 0 ]
              // [ 0 1 0 0 ]
              // [ 0 0 1 z ]
              // [ 0 0 0 1 ]
              // ..rotateX(0.5),
              ..rotateY(controller.value * pi),
            // ..rotateZ(0.7),
            alignment: FractionalOffset.center,
            child: Center(
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  xPosition = details.localPosition.dx;
                },
                onHorizontalDragUpdate: (details) {
                  var dis = xPosition - details.localPosition.dx;
                  dis = dis.clamp(-60, 60);
                  controller.value = dis / 500;
                },
                onHorizontalDragEnd: (_) async {
                  controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 200),
                  );
                },
                child: SizedBox(
                  width: 300,
                  height: 180,
                  child: CustomPaint(
                    painter: CardPainter(
                      color: const Color.fromARGB(255, 104, 34, 208),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final Color color;

  CardPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 300,
          height: 180,
        ),
        const Radius.circular(10),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
