import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/tokens.dart';
import '../game/model.dart';
import '../game/rules.dart';

class BoardFit extends StatelessWidget {
  const BoardFit({required this.cols, required this.rows, required this.child, super.key});

  final int cols;
  final int rows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        if (maxW <= 0 || maxH <= 0 || !maxW.isFinite || !maxH.isFinite) {
          return const SizedBox.shrink();
        }
        var width = maxW;
        var height = width * rows / cols;
        if (height > maxH) {
          height = maxH;
          width = height * cols / rows;
        }
        return SizedBox(width: width, height: height, child: child);
      },
    );
  }
}

class ArrowBoard extends StatelessWidget {
  const ArrowBoard({
    required this.level,
    required this.removed,
    this.exitingId,
    this.exitDir,
    this.exitT = 0,
    this.bumpingId,
    this.bumpDir,
    this.bumpT = 0,
    this.hintId,
    this.hintT = 0,
    this.coachCell,
    this.coachPressed = false,
    this.onTap,
    this.labelFor,
    super.key,
  });

  final PuzzleLevel level;
  final Set<int> removed;
  final int? exitingId;
  final Direction? exitDir;
  final double exitT;
  final int? bumpingId;
  final Direction? bumpDir;
  final double bumpT;
  final int? hintId;
  final double hintT;
  final Cell? coachCell;
  final bool coachPressed;
  final ValueChanged<int>? onTap;
  final String Function(ArrowPiece arrow)? labelFor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = constraints.maxWidth / level.cols;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: onTap == null
                    ? null
                    : (details) {
                        final id = hitArrow(details.localPosition, cell, level, removed);
                        if (id != null) onTap!(id);
                      },
                child: CustomPaint(
                  painter: ArrowBoardPainter(
                    level: level,
                    removed: removed,
                    exitingId: exitingId,
                    exitDir: exitDir,
                    exitT: exitT,
                    bumpingId: bumpingId,
                    bumpDir: bumpDir,
                    bumpT: bumpT,
                    hintId: hintId,
                    hintT: hintT,
                    coachCell: coachCell,
                    coachPressed: coachPressed,
                  ),
                ),
              ),
            ),
            if (labelFor != null)
              for (final arrow in level.arrows)
                if (!removed.contains(arrow.id) || arrow.id == exitingId)
                  Positioned(
                    left: arrow.head.x * cell,
                    top: arrow.head.y * cell,
                    width: cell,
                    height: cell,
                    child: Semantics(
                      button: onTap != null,
                      label: labelFor!(arrow),
                      onTap: onTap == null ? null : () => onTap!(arrow.id),
                      child: const SizedBox.expand(),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

int? hitArrow(Offset pos, double cell, PuzzleLevel level, Set<int> removed) {
  int? best;
  for (final arrow in level.arrows) {
    if (removed.contains(arrow.id)) continue;
    for (final spot in arrow.cells) {
      final rect = Rect.fromLTWH(spot.x * cell, spot.y * cell, cell, cell);
      if (rect.contains(pos)) best = arrow.id;
    }
  }
  return best;
}

class ArrowBoardPainter extends CustomPainter {
  ArrowBoardPainter({
    required this.level,
    required this.removed,
    required this.exitingId,
    required this.exitDir,
    required this.exitT,
    required this.bumpingId,
    required this.bumpDir,
    required this.bumpT,
    required this.hintId,
    required this.hintT,
    required this.coachCell,
    required this.coachPressed,
  });

  final PuzzleLevel level;
  final Set<int> removed;
  final int? exitingId;
  final Direction? exitDir;
  final double exitT;
  final int? bumpingId;
  final Direction? bumpDir;
  final double bumpT;
  final int? hintId;
  final double hintT;
  final Cell? coachCell;
  final bool coachPressed;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / level.cols;
    final arrows = [...level.arrows]
      ..sort((a, b) {
        final aActive = a.id == exitingId || a.id == bumpingId ? 1 : 0;
        final bActive = b.id == exitingId || b.id == bumpingId ? 1 : 0;
        return aActive.compareTo(bActive);
      });
    for (final arrow in arrows) {
      final exiting = arrow.id == exitingId;
      if (removed.contains(arrow.id) && !exiting) continue;
      final slide = _slide(arrow, cell);
      final color = _color(arrow);
      final opacity = exiting ? (exitT < 0.72 ? 1.0 : (1 - (exitT - 0.72) / 0.28).clamp(0.0, 1.0)) : 1.0;
      if (arrow.id == hintId) {
        final center = _centroid(arrow, cell, slide);
        canvas.save();
        final scale = 1 + 0.045 * hintT;
        canvas.translate(center.dx, center.dy);
        canvas.scale(scale);
        canvas.translate(-center.dx, -center.dy);
        _drawClayPiece(canvas, arrow, cell, slide, color, opacity, emphasize: true);
        canvas.restore();
      } else {
        _drawClayPiece(canvas, arrow, cell, slide, color, opacity, emphasize: false);
      }
    }

    final coach = coachCell;
    if (coach != null) {
      final center = Offset((coach.x + 0.5) * cell, (coach.y + 0.5) * cell);
      final radius = cell * (coachPressed ? 0.28 : 0.34);
      canvas.drawCircle(center, radius, Paint()..color = const Color(0x66FFF8F0));
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.ink.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.5, cell * 0.045),
      );
    }
  }

  Offset _slide(ArrowPiece arrow, double cell) {
    if (arrow.id == exitingId && exitDir != null) {
      final steps = Rules.travel(level, arrow, exitDir!);
      return _unit(exitDir!) * cell * steps.toDouble() * exitT;
    }
    if (arrow.id == bumpingId && bumpDir != null) {
      return _unit(bumpDir!) * cell * 0.28 * math.sin(math.pi * bumpT);
    }
    return Offset.zero;
  }

  Color _color(ArrowPiece arrow) {
    final base = AppColors.clayFor(arrow.id);
    if (arrow.id == bumpingId) {
      return Color.lerp(base, AppColors.danger, math.sin(math.pi * bumpT))!;
    }
    if (arrow.id == hintId) {
      return Color.lerp(base, AppColors.blue, 0.28 + 0.42 * hintT)!;
    }
    return base;
  }

  @override
  bool shouldRepaint(covariant ArrowBoardPainter oldDelegate) => true;
}

void _drawClayPiece(
  Canvas canvas,
  ArrowPiece arrow,
  double cell,
  Offset slide,
  Color color,
  double opacity, {
  required bool emphasize,
}) {
  final inset = cell * 0.09;
  for (final spot in arrow.cells) {
    final rect = Rect.fromLTWH(
      spot.x * cell + inset + slide.dx,
      spot.y * cell + inset + slide.dy,
      cell - inset * 2,
      cell - inset * 2,
    );
    _drawClayTile(canvas, rect, color, opacity);
    if (emphasize) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(cell * 0.02), Radius.circular(rect.shortestSide * 0.30)),
        Paint()
          ..color = AppColors.blue.withValues(alpha: 0.55 * opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * 0.045,
      );
    }
  }
  _drawClayGlyph(canvas, _cellCenter(arrow.head, cell, slide), arrow.dir, cell, opacity);
  final alt = arrow.alt;
  if (alt != null && (arrow.cells.length > 1 || alt != arrow.dir)) {
    _drawClayGlyph(canvas, _cellCenter(arrow.tail, cell, slide), alt, cell, opacity);
  }
}

void _drawClayTile(Canvas canvas, Rect rect, Color color, double opacity) {
  final radius = Radius.circular(rect.shortestSide * 0.30);
  final tile = RRect.fromRectAndRadius(rect, radius);
  canvas.drawRRect(
    tile.shift(Offset(rect.width * 0.055, rect.height * 0.085)),
    Paint()
      ..color = const Color(0xFF5C4636).withValues(alpha: 0.22 * opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, rect.shortestSide * 0.09),
  );
  canvas.drawRRect(
    tile,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, Colors.white, 0.34)!.withValues(alpha: opacity),
          color.withValues(alpha: opacity),
          Color.lerp(color, const Color(0xFF3A2A22), 0.24)!.withValues(alpha: opacity),
        ],
        stops: const [0.0, 0.42, 1.0],
      ).createShader(rect),
  );
  canvas.save();
  canvas.clipRRect(tile);
  canvas.drawOval(
    Rect.fromCenter(
      center: rect.center + Offset(-rect.width * 0.22, -rect.height * 0.26),
      width: rect.width * 0.46,
      height: rect.height * 0.22,
    ),
    Paint()..color = Colors.white.withValues(alpha: 0.40 * opacity),
  );
  canvas.restore();
}

void _drawClayGlyph(Canvas canvas, Offset center, Direction dir, double cell, double opacity) {
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(switch (dir) {
    Direction.right => 0.0,
    Direction.down => math.pi / 2,
    Direction.left => math.pi,
    Direction.up => -math.pi / 2,
  });
  final width = cell * 0.56;
  final height = cell * 0.38;
  final path = _clayArrowPath(width, height);
  canvas.drawPath(
    path.shift(Offset(cell * 0.012, cell * 0.022)),
    Paint()
      ..color = const Color(0xFF5C4636).withValues(alpha: 0.28 * opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, cell * 0.03),
  );
  final bounds = Rect.fromCenter(center: Offset.zero, width: width, height: height);
  canvas.drawPath(
    path,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: opacity),
          AppColors.arrow.withValues(alpha: opacity),
          const Color(0xFFE7D5C4).withValues(alpha: opacity),
        ],
        stops: const [0.0, 0.48, 1.0],
      ).createShader(bounds),
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = AppColors.arrow.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = cell * 0.055
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round,
  );
  canvas.restore();
}

Path _clayArrowPath(double width, double height) {
  final shaft = height * 0.46;
  final head = width * 0.40;
  final left = -width / 2;
  final right = width / 2;
  final neck = right - head;
  return Path()
    ..moveTo(left, -shaft / 2)
    ..lineTo(neck, -shaft / 2)
    ..lineTo(neck, -height / 2)
    ..lineTo(right, 0)
    ..lineTo(neck, height / 2)
    ..lineTo(neck, shaft / 2)
    ..lineTo(left, shaft / 2)
    ..close();
}

Offset _cellCenter(Cell spot, double cell, Offset slide) {
  return Offset((spot.x + 0.5) * cell, (spot.y + 0.5) * cell) + slide;
}

Offset _centroid(ArrowPiece arrow, double cell, Offset slide) {
  var x = 0.0;
  var y = 0.0;
  for (final spot in arrow.cells) {
    x += spot.x + 0.5;
    y += spot.y + 0.5;
  }
  final n = arrow.cells.length;
  return Offset(x / n * cell, y / n * cell) + slide;
}

Offset _unit(Direction dir) => Offset(dir.dx.toDouble(), dir.dy.toDouble());
