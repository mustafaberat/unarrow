import 'dart:async';

import 'package:flutter/material.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/model.dart';
import '../l10n/app_localizations.dart';
import '../widgets/arrow_board.dart';

/// The lesson is the board playing itself. One short line, then it loops.
class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({required this.firstRun, super.key});

  final bool firstRun;

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> with SingleTickerProviderStateMixin {
  static final PuzzleLevel _demo = PuzzleLevel(
    cols: 3,
    rows: 4,
    arrows: const [
      ArrowPiece(id: 0, dir: Direction.up, cells: [Cell(1, 0)]),
      ArrowPiece(id: 0, dir: Direction.up, cells: [Cell(1, 1)]),
      ArrowPiece(id: 0, dir: Direction.up, cells: [Cell(1, 2)]),
    ],
  );

  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4800),
  );

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logHowToPlayOpen(
      widget.firstRun ? AnalyticsValues.firstRun : AnalyticsValues.settings,
    );
    AnalyticsService.instance.logScreen(AnalyticsValues.howTo);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);
    if (reduce) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.page, 8, AppDimens.page, AppDimens.page),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _close, child: Text(l10n.skip)),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360, maxHeight: 460),
                    child: AnimatedBuilder(
                      animation: _loop,
                      builder: (context, _) {
                        final frame = reduce ? _Pose.still : _pose(_loop.value);
                        return BoardFit(
                          cols: _demo.cols,
                          rows: _demo.rows,
                          child: ArrowBoard(
                            level: _demo,
                            removed: frame.removed,
                            exitingId: frame.exitingId,
                            exitDir: frame.exitingId == null ? null : Direction.up,
                            exitT: frame.exitT,
                            coachCell: frame.coach,
                            coachPressed: frame.pressed,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Text(
                l10n.howToLine,
                textAlign: TextAlign.center,
                style: theme.titleLarge,
              ),
              const SizedBox(height: AppDimens.gapL),
              if (widget.firstRun)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: _play, child: Text(l10n.play)),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: _close, child: Text(l10n.back)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _close() {
    final settings = AppScope.read(context).settings;
    Navigator.of(context).pop();
    unawaited(settings.setOnboardingDone(true));
  }

  void _play() {
    final settings = AppScope.read(context).settings;
    unawaited(settings.setOnboardingDone(true));
    Navigator.of(context).pushReplacementNamed(AppRoutes.play);
  }
}

class _Pose {
  const _Pose({
    required this.removed,
    this.exitingId,
    this.exitT = 0,
    this.coach,
    this.pressed = false,
  });

  static const still = _Pose(removed: {0}, coach: Cell(1, 1));

  final Set<int> removed;
  final int? exitingId;
  final double exitT;
  final Cell? coach;
  final bool pressed;
}

_Pose _pose(double t) {
  final ms = t * 4800;
  const top = Cell(1, 0);
  const mid = Cell(1, 1);
  const low = Cell(1, 2);
  if (ms < 500) return const _Pose(removed: {});
  if (ms < 900) return const _Pose(removed: {}, coach: top);
  if (ms < 1050) return const _Pose(removed: {}, coach: top, pressed: true);
  if (ms < 1550) {
    return _Pose(removed: const {}, exitingId: 0, exitT: (ms - 1050) / 500, coach: top);
  }
  if (ms < 1950) return const _Pose(removed: {0}, coach: mid);
  if (ms < 2100) return const _Pose(removed: {0}, coach: mid, pressed: true);
  if (ms < 2700) {
    return _Pose(removed: const {0}, exitingId: 1, exitT: (ms - 2100) / 600, coach: mid);
  }
  if (ms < 3100) return const _Pose(removed: {0, 1}, coach: low);
  if (ms < 3250) return const _Pose(removed: {0, 1}, coach: low, pressed: true);
  if (ms < 3900) {
    return _Pose(removed: const {0, 1}, exitingId: 2, exitT: (ms - 3250) / 650, coach: low);
  }
  return const _Pose(removed: {0, 1, 2});
}
