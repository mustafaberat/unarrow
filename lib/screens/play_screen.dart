import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/levels.dart';
import '../game/model.dart';
import '../game/rules.dart';
import '../l10n/app_localizations.dart';
import '../widgets/arrow_board.dart';
import '../widgets/hearts.dart';

enum _CardKind { clear, fail, done }

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  GameSession? _session;
  int _index = 0;
  DateTime _started = DateTime.now();
  bool _ended = false;
  bool _leaving = false;
  bool _paused = false;
  bool _perfect = false;
  _CardKind? _card;
  int? _hintId;
  int? _exitingId;
  Direction? _exitDir;
  int? _bumpingId;
  Direction? _bumpDir;

  late final AnimationController _exit;
  late final AnimationController _bump;
  late final AnimationController _hintPulse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _exit = AnimationController(vsync: this, duration: const Duration(milliseconds: 420))
      ..addListener(() => setState(() {}))
      ..addStatusListener(_onExitStatus);
    _bump = AnimationController(vsync: this, duration: AppMotion.bump)
      ..addListener(() => setState(() {}))
      ..addStatusListener(_onBumpStatus);
    _hintPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 760))
      ..addListener(() => setState(() {}));
    AnalyticsService.instance.logScreen(AnalyticsValues.play);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_session != null) return;
    _load(AppScope.of(context).progress.nextIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _exit.dispose();
    _bump.dispose();
    _hintPulse.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.paused && state != AppLifecycleState.hidden) return;
    if (_exit.isAnimating) _exit.value = 1;
    if (_bump.isAnimating) _bump.value = 1;
    _hintPulse.stop();
    if (mounted && _card == null) setState(() => _paused = true);
  }

  void _load(int index) {
    _index = index.clamp(0, Levels.all.length - 1);
    _session = GameSession(Levels.all[_index]);
    _started = DateTime.now();
    _ended = false;
    _paused = false;
    _perfect = false;
    _card = null;
    _hintId = null;
    _exitingId = null;
    _exitDir = null;
    _bumpingId = null;
    _bumpDir = null;
    _hintPulse.stop();
    AnalyticsService.instance.logLevelStart(_index + 1);
  }

  bool get _busy => _exitingId != null || _bumpingId != null || _card != null || _paused;

  int get _seconds => DateTime.now().difference(_started).inSeconds;

  void _onExitStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _exitingId == null || !mounted) return;
    final won = _session?.won ?? false;
    setState(() => _exitingId = null);
    if (won) _finishClear();
  }

  void _onBumpStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _bumpingId == null || !mounted) return;
    final lost = _session?.lost ?? false;
    setState(() => _bumpingId = null);
    if (lost) _finishFail();
  }

  void _finishClear() {
    final session = _session;
    if (session == null) return;
    _perfect = session.hearts == GameRules.hearts;
    final last = _index + 1 >= Levels.all.length;
    _logEnd(AnalyticsValues.clear);
    setState(() => _card = last ? _CardKind.done : _CardKind.clear);
    unawaited(AppScope.read(context).progress.onCleared(_index));
    _pulse(success: true);
  }

  void _finishFail() {
    _logEnd(AnalyticsValues.fail);
    setState(() => _card = _CardKind.fail);
  }

  void _logEnd(String result) {
    final session = _session;
    if (session == null || _ended) return;
    _ended = true;
    AnalyticsService.instance.logLevelEnd(
      level: _index + 1,
      result: result,
      durationSec: _seconds,
      heartsLeft: session.hearts,
      hintsUsed: GameRules.hints - session.hints,
    );
  }

  void _logQuit(String from) {
    final session = _session;
    if (session == null || _ended) return;
    _ended = true;
    AnalyticsService.instance.logLevelQuit(
      level: _index + 1,
      durationSec: _seconds,
      heartsLeft: session.hearts,
      from: from,
    );
  }

  void _tap(int id) {
    final session = _session;
    if (session == null || _busy) return;
    final result = session.tap(id);
    switch (result) {
      case TapIgnored():
        return;
      case TapBumped(:final dir):
        _hintId = null;
        _hintPulse.stop();
        _bumpingId = id;
        _bumpDir = dir;
        _pulse(success: false);
        final reduce = AppScope.read(context).settings.reduceMotionFor(context);
        _bump.duration = reduce ? const Duration(milliseconds: 1) : AppMotion.bump;
        _bump.forward(from: 0);
        setState(() {});
      case TapCleared(:final dir):
        _hintId = null;
        _hintPulse.stop();
        _exitingId = id;
        _exitDir = dir;
        _pulse(success: true);
        final reduce = AppScope.read(context).settings.reduceMotionFor(context);
        final steps = Rules.travel(session.level, session.level.arrows[id], dir);
        final ms = reduce ? 1 : (200 + steps * 48).clamp(240, 780);
        _exit.duration = Duration(milliseconds: ms);
        _exit.forward(from: 0);
        setState(() {});
    }
  }

  void _hint() {
    final session = _session;
    final l10n = AppLocalizations.of(context);
    if (session == null || _busy) return;
    if (session.hints <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noHints)));
      return;
    }
    final id = session.useHint();
    if (id == null) return;
    setState(() => _hintId = id);
    final reduce = AppScope.read(context).settings.reduceMotionFor(context);
    if (reduce) {
      _hintPulse.value = 1;
    } else {
      _hintPulse.repeat(reverse: true);
    }
  }

  void _pulse({required bool success}) {
    final settings = AppScope.read(context).settings;
    if (settings.haptics) {
      if (success) {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.mediumImpact();
      }
    }
    if (settings.sound) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _resume() {
    setState(() => _paused = false);
    final reduce = AppScope.read(context).settings.reduceMotionFor(context);
    if (_hintId != null && !reduce) _hintPulse.repeat(reverse: true);
  }

  void _restart() {
    _logQuit(AnalyticsValues.restart);
    setState(() => _load(_index));
  }

  void _retry() {
    setState(() => _load(_index));
  }

  void _next() {
    if (_index + 1 >= Levels.all.length) return;
    setState(() => _load(_index + 1));
  }

  Future<void> _playAgain() async {
    await AppScope.read(context).progress.reset();
    if (!mounted) return;
    setState(() => _load(0));
  }

  void _home({required bool quit}) {
    if (quit) _logQuit(AnalyticsValues.home);
    setState(() => _leaving = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _onBack() {
    if (_leaving) return;
    if (_card == _CardKind.fail || _card == _CardKind.clear || _card == _CardKind.done) return;
    if (_paused) {
      _resume();
      return;
    }
    setState(() => _paused = true);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);

    return PopScope(
      canPop: _leaving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 52,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(l10n.levelLabel(_index + 1), style: theme.titleLarge),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: _busy && !_paused ? null : () => setState(() => _paused = true),
                              icon: const Icon(Icons.pause_rounded),
                              tooltip: l10n.pause,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Hearts(count: session.hearts, label: l10n.hearts(session.hearts)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                        child: Center(
                          child: BoardFit(
                            cols: session.level.cols,
                            rows: session.level.rows,
                            child: ArrowBoard(
                              level: session.level,
                              removed: session.removed,
                              exitingId: _exitingId,
                              exitDir: _exitDir,
                              exitT: reduce ? (_exitingId == null ? 0 : 1) : Curves.easeIn.transform(_exit.value),
                              bumpingId: _bumpingId,
                              bumpDir: _bumpDir,
                              bumpT: _bump.value,
                              hintId: _hintId,
                              hintT: reduce ? 1 : _hintPulse.value,
                              onTap: _tap,
                              labelFor: _label,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _HintButton(
                      enabled: session.hints > 0,
                      tooltip: l10n.hint,
                      onPressed: _hint,
                    ),
                  ),
                ],
              ),
              if (_paused) _panel(_pausePanel(l10n)),
              if (_card != null) _panel(_resultPanel(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  String _label(ArrowPiece arrow) {
    final l10n = AppLocalizations.of(context);
    if (arrow.alt != null) return l10n.arrowEither;
    return switch (arrow.dir) {
      Direction.up => l10n.arrowUp,
      Direction.down => l10n.arrowDown,
      Direction.left => l10n.arrowLeft,
      Direction.right => l10n.arrowRight,
    };
  }

  Widget _panel(Widget child) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: ColoredBox(
          color: AppColors.scrim,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pausePanel(AppLocalizations l10n) {
    return _MenuCard(
      title: l10n.paused,
      actions: [
        FilledButton(onPressed: _resume, child: Text(l10n.resume)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: _restart, child: Text(l10n.restart)),
        TextButton(
          onPressed: () {
            AnalyticsService.instance.logHowToPlayOpen(AnalyticsValues.play);
            Navigator.of(context).pushNamed(AppRoutes.howTo);
          },
          child: Text(l10n.howToPlay),
        ),
        TextButton(onPressed: () => _home(quit: true), child: Text(l10n.home)),
      ],
    );
  }

  Widget _resultPanel(AppLocalizations l10n) {
    final clear = _card == _CardKind.clear || _card == _CardKind.done;
    final title = switch (_card) {
      _CardKind.fail => l10n.noHearts,
      _CardKind.done => l10n.allClear,
      _ => l10n.levelClear,
    };
    return _MenuCard(
      title: title,
      subtitle: clear && _perfect ? l10n.noHeartsLost : null,
      icon: clear ? Icons.check_rounded : Icons.heart_broken_rounded,
      iconColor: clear ? AppColors.green : AppColors.danger,
      actions: [
        if (_card == _CardKind.fail)
          FilledButton(onPressed: _retry, child: Text(l10n.tryAgain))
        else if (_card == _CardKind.done)
          FilledButton(onPressed: _playAgain, child: Text(l10n.playAgain))
        else
          FilledButton(onPressed: _next, child: Text(l10n.nextLevel)),
        const SizedBox(height: 8),
        TextButton(onPressed: () => _home(quit: false), child: Text(l10n.home)),
      ],
    );
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({required this.enabled, required this.tooltip, required this.onPressed});

  final bool enabled;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: 1,
        shadowColor: const Color(0x22000000),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: AppDimens.hintSize,
            height: AppDimens.hintSize,
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: enabled ? AppColors.blue : AppColors.faint,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.actions,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Material(
        color: AppColors.surface,
        elevation: 6,
        shadowColor: const Color(0x22000000),
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor, size: 36),
                const SizedBox(height: 8),
              ],
              Text(title, textAlign: TextAlign.center, style: theme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, textAlign: TextAlign.center, style: theme.bodyMedium),
              ],
              const SizedBox(height: 18),
              ...actions.map(
                (action) => SizedBox(width: double.infinity, child: action),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
