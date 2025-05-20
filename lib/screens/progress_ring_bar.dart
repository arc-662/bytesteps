import 'package:flutter/material.dart';

class ProgressRingPainter extends CustomPainter {
  final double progress; // from 0.0 to 1.0

  ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle (grey)
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw gradient arc
    final gradient = SweepGradient(
      colors: [
        Colors.yellow,
        Colors.red,
        Colors.orange,
        Colors.purple,
        Colors.pink,
        Colors.yellow, // Close the loop
      ],
      startAngle: 0.0,
      endAngle: 3.14 * 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -90 * (3.1416 / 180); // Start from top
    final sweepAngle = progress * 2 * 3.1416; // Progress portion

    canvas.drawArc(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
