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
  var bestDist = cell * 0.52;
  for (final arrow in level.arrows) {
    if (removed.contains(arrow.id)) continue;
    final points = _points(arrow, cell, Offset.zero);
    for (var i = 0; i < points.length - 1; i++) {
      final dist = _segmentDistance(pos, points[i], points[i + 1]);
      if (dist < bestDist) {
        bestDist = dist;
        best = arrow.id;
      }
    }
    final tip = points.last + _unit(arrow.dir) * cell * 0.46;
    final tipDist = (tip - pos).distance;
    if (tipDist < bestDist) {
      bestDist = tipDist;
      best = arrow.id;
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
    final dot = Paint()..color = AppColors.dot;
    for (var y = 0; y < level.rows; y++) {
      for (var x = 0; x < level.cols; x++) {
        canvas.drawCircle(Offset((x + 0.5) * cell, (y + 0.5) * cell), math.max(1.4, cell * 0.045), dot);
      }
    }

    final arrows = [...level.arrows]..sort((a, b) {
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
      _drawArrow(canvas, arrow, cell, slide, color.withValues(alpha: opacity));
    }

    final coach = coachCell;
    if (coach != null) {
      final center = Offset((coach.x + 0.5) * cell, (coach.y + 0.5) * cell);
      final radius = cell * (coachPressed ? 0.28 : 0.34);
      canvas.drawCircle(center, radius, Paint()..color = const Color(0x66FFFFFF));
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
    if (arrow.id == bumpingId) {
      return Color.lerp(AppColors.ink, AppColors.danger, math.sin(math.pi * bumpT))!;
    }
    if (arrow.id == hintId) {
      return Color.lerp(AppColors.ink, AppColors.blue, 0.45 + 0.55 * hintT)!;
    }
    return AppColors.ink;
  }

  @override
  bool shouldRepaint(covariant ArrowBoardPainter oldDelegate) => true;
}

void _drawArrow(Canvas canvas, ArrowPiece arrow, double cell, Offset slide, Color color) {
  final points = _points(arrow, cell, slide);
  final stroke = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = cell * 0.36
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final shaft = _shaft(points, arrow.dir, arrow.alt, cell);
  if (shaft.length == 1) {
    canvas.drawCircle(shaft.single, cell * 0.08, Paint()..color = color);
  } else {
    final path = Path()..moveTo(shaft.first.dx, shaft.first.dy);
    for (final point in shaft.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, stroke);
  }
  _drawHead(canvas, points.last, arrow.dir, cell, color);
  final alt = arrow.alt;
  if (alt != null) _drawHead(canvas, points.first, alt, cell, color);
}

List<Offset> _shaft(List<Offset> points, Direction dir, Direction? alt, double cell) {
  if (points.length == 1) {
    final back = points.single - _unit(dir) * cell * 0.2;
    return [back, points.single - _unit(dir) * cell * 0.02];
  }
  final copy = [...points];
  copy[copy.length - 1] = _trim(copy[copy.length - 2], copy.last, cell * 0.2);
  if (alt != null) {
    copy[0] = _trim(copy[1], copy.first, cell * 0.2);
  }
  return copy;
}

Offset _trim(Offset from, Offset end, double cut) {
  final delta = end - from;
  final len = delta.distance;
  if (len <= 1) return end;
  return end - delta / len * math.min(cut, len * 0.45);
}

void _drawHead(Canvas canvas, Offset at, Direction dir, double cell, Color color) {
  final forward = _unit(dir);
  final side = Offset(-forward.dy, forward.dx);
  final tip = at + forward * cell * 0.48;
  final base = at + forward * cell * 0.05;
  final wing = cell * 0.27;
  final path = Path()
    ..moveTo(tip.dx, tip.dy)
    ..lineTo((base + side * wing).dx, (base + side * wing).dy)
    ..lineTo((base - side * wing).dx, (base - side * wing).dy)
    ..close();
  canvas.drawPath(path, Paint()..color = color);
}

List<Offset> _points(ArrowPiece arrow, double cell, Offset slide) {
  return [
    for (final spot in arrow.cells) Offset((spot.x + 0.5) * cell, (spot.y + 0.5) * cell) + slide,
  ];
}

Offset _unit(Direction dir) => Offset(dir.dx.toDouble(), dir.dy.toDouble());

double _segmentDistance(Offset point, Offset a, Offset b) {
  final ab = b - a;
  final length2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (length2 == 0) return (point - a).distance;
  final t = ((point - a).dx * ab.dx + (point - a).dy * ab.dy) / length2;
  final clamped = t.clamp(0.0, 1.0);
  return (point - (a + ab * clamped)).distance;
}
