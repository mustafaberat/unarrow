import 'package:flutter/material.dart';

import '../config/tokens.dart';
import '../game/rules.dart';

class Hearts extends StatelessWidget {
  const Hearts({required this.count, required this.label, super.key});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < GameRules.hearts; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: CustomPaint(
                size: const Size(28, 26),
                painter: _ClayHeartPainter(filled: i < count),
              ),
            ),
        ],
      ),
    );
  }
}

class _ClayHeartPainter extends CustomPainter {
  const _ClayHeartPainter({required this.filled});

  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _heart(size);
    if (!filled) {
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.heartEmpty
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
      return;
    }

    canvas.drawPath(
      path.shift(const Offset(0.4, 1.6)),
      Paint()
        ..color = const Color(0x335C4636)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(AppColors.heart, Colors.white, 0.34)!,
            AppColors.heart,
            Color.lerp(AppColors.heart, const Color(0xFF8C3A32), 0.22)!,
          ],
          stops: const [0.0, 0.46, 1.0],
        ).createShader(Offset.zero & size),
    );
    canvas.save();
    canvas.clipPath(path);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.34, size.height * 0.32),
        width: size.width * 0.24,
        height: size.height * 0.14,
      ),
      Paint()..color = const Color(0x99FFFFFF),
    );
    canvas.restore();
  }

  Path _heart(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.50, h * 0.90)
      ..cubicTo(w * 0.02, h * 0.56, w * -0.04, h * 0.18, w * 0.28, h * 0.14)
      ..cubicTo(w * 0.42, h * 0.11, w * 0.48, h * 0.24, w * 0.50, h * 0.34)
      ..cubicTo(w * 0.52, h * 0.24, w * 0.58, h * 0.11, w * 0.72, h * 0.14)
      ..cubicTo(w * 1.04, h * 0.18, w * 0.98, h * 0.56, w * 0.50, h * 0.90)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _ClayHeartPainter oldDelegate) => oldDelegate.filled != filled;
}
