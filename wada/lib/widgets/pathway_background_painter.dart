
// lib/widgets/pathway_background_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PathwayBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color accentColor;

  PathwayBackgroundPainter({
    required this.animation,
    required this.accentColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final sparklesPaint = Paint()
      ..color = accentColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Dessiner une grille de points
    for (int i = 0; i < size.width / 40; i++) {
      for (int j = 0; j < size.height / 40; j++) {
        final offset = Offset(i * 40.0, j * 40.0);

        // Ligne verticale
        if (i < size.width / 40 - 1) {
          canvas.drawLine(
            offset,
            Offset(offset.dx + 40, offset.dy),
            paint,
          );
        }
        // Ligne horizontale
        if (j < size.height / 40 - 1) {
          canvas.drawLine(
            offset,
            Offset(offset.dx, offset.dy + 40),
            paint,
          );
        }

        // Dessiner des particules scintillantes
        if ((i + j + animation.value * 10).toInt() % 7 == 0) {
          final sparkleSize =
              2 + math.sin(animation.value * 2 * math.pi + i + j) * 1;
          canvas.drawCircle(
            offset,
            sparkleSize,
            sparklesPaint,
          );
        }
      }
    }

    // Dessiner des formes géométriques flottantes
    final geometryPaint = Paint()
      ..color = accentColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final centerX =
          size.width * (0.2 + 0.6 * math.sin(animation.value * 2 * math.pi + i));
      final centerY = size.height *
          (0.3 + 0.4 * math.cos(animation.value * 2 * math.pi + i * 1.5));
      final radius = 20 + 10 * math.sin(animation.value * 4 * math.pi + i);
      final path = Path();
      for (int j = 0; j < 6; j++) {
        final angle = j * math.pi / 3;
        final x = centerX + radius * math.cos(angle);
        final y = centerY + radius * math.sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, geometryPaint);
    }
  }

  @override
  bool shouldRepaint(PathwayBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}