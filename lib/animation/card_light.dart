import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CardLight extends StatefulWidget {
  const CardLight({super.key});

  @override
  State<CardLight> createState() => _CardLightState();
}

class _CardLightState extends State<CardLight>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  double xPosition = 0.0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: -0.2,
      upperBound: 0.2,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Card Light'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Transform(
              transform: Matrix4.identity()
                ..rotateY(controller.value * pi)
                ..rotateZ(-0.1 * pi)
                ..setEntry(3, 2, 0.001),
              alignment: Alignment.center,
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  xPosition = details.localPosition.dx;
                },
                onHorizontalDragUpdate: (details) {
                  var dis = xPosition - details.localPosition.dx;
                  if (dis < 0) {
                    return;
                  }
                  dis = dis.clamp(-60, 60);
                  controller.value = dis / 400;
                },
                onHorizontalDragEnd: (_) {
                  controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.bounceOut,
                  );
                },
                child: SizedBox(
                  width: 220,
                  height: 350,
                  child: CustomPaint(
                    painter: CardPainter(
                      color: const Color.fromARGB(255, 255, 79, 79),
                      value: controller.value,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final Color color;
  final double value;

  CardPainter({
    required this.color,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final position = (value) * 100 / 15;

    Paint paint = Paint()
      ..color = color
      ..shader = ui.Gradient.radial(
        Offset(
          size.width / 20 * (position * 15 + 1),
          size.height / 4 * (position * 1.3 + 1),
        ),
        300,
        [
          const Color.fromARGB(255, 255, 213, 213),
          const Color.fromARGB(255, 255, 79, 79),
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
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
