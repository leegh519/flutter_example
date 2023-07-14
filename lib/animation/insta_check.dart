import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

///
/// https://stackoverflow.com/questions/50978603/how-to-animate-a-path-in-flutter
///

class InstaCheck extends StatefulWidget {
  const InstaCheck({super.key});

  @override
  State<InstaCheck> createState() => _InstaCheckState();
}

class _InstaCheckState extends State<InstaCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: CheckPainter(controller.value),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CheckPainter extends CustomPainter {
  final double value;

  CheckPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..strokeWidth = max(30 - 44 * value, 8)
      ..shader = ui.Gradient.linear(
        const Offset(0, 100),
        const Offset(100, 0),
        [
          const Color.fromARGB(255, 228, 153, 50),
          const Color.fromARGB(255, 234, 104, 60),
          const Color.fromARGB(255, 169, 10, 58),
          const Color.fromARGB(255, 147, 34, 122),
        ],
        [0, 0.1, 0.4, 1],
      )
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      min(30 + 140 * value, 100),
      circlePaint,
    );
    Paint linePaint = Paint()
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.2, size.height * 0.5),
        Offset(size.width * 0.8, size.height * 0.5),
        [
          const Color.fromARGB(255, 228, 153, 50),
          const Color.fromARGB(255, 234, 104, 60),
          const Color.fromARGB(255, 169, 10, 58),
          const Color.fromARGB(255, 147, 34, 122),
        ],
        [0, 0.1, 0.4, 1],
      )
      ..style = PaintingStyle.stroke;
    Path path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.4 - 5, size.height * 0.72 - 5)
      ..arcToPoint(
        Offset(size.width * 0.4 + 5, size.height * 0.72 - 5),
        radius: const Radius.circular(7),
        clockwise: false,
      )
      ..lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(createAnimatedPath(path, value * 2 - 1), linePaint);
  }

  Path createAnimatedPath(Path path, double animationValue) {
    final totalLength = path
        .computeMetrics()
        .fold(0.0, (prev, metrics) => prev + metrics.length);
    final currentLength = totalLength * animationValue;

    return drawPathUntilLength(path, currentLength);
  }

  Path drawPathUntilLength(Path originalPath, double length) {
    final path = Path();
    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metrics = metricsIterator.current;
      final pathSegment = metrics.extractPath(0.0, length);
      path.addPath(pathSegment, Offset.zero);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
