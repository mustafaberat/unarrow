import 'package:flutter/material.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/levels.dart';
import '../l10n/app_localizations.dart';
import '../widgets/arrow_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen(AnalyticsValues.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = AppScope.read(context).settings;
      if (settings.onboardingDone) return;
      Navigator.of(context).pushNamed(AppRoutes.howTo, arguments: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = AppScope.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= AppDimens.wide;
    final preview = Levels.all[4];

    final board = IgnorePointer(
      child: BoardFit(
        cols: preview.cols,
        rows: preview.rows,
        child: ArrowBoard(level: preview, removed: const {}),
      ),
    );
    final copy = ListenableBuilder(
      listenable: services.progress,
      builder: (context, _) {
        final progress = services.progress;
        final levelText = progress.finishedAll ? l10n.allClear : l10n.levelLabel(progress.levelNumber);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.appTitle, style: theme.headlineLarge),
            const SizedBox(height: 8),
            Text(l10n.homeTagline, style: theme.bodyMedium),
            const SizedBox(height: AppDimens.gapL),
            Text(levelText, style: theme.titleMedium),
            const SizedBox(height: AppDimens.gap),
            FilledButton(
              onPressed: () => _play(context),
              child: Text(progress.finishedAll ? l10n.playAgain : l10n.play),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {
                AnalyticsService.instance.logSettingsOpen(AnalyticsValues.home);
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
              child: Text(l10n.settings),
            ),
          ],
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.page),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: wide ? 920 : AppDimens.maxContent),
              child: wide
                  ? Row(
                      children: [
                        Expanded(child: board),
                        const SizedBox(width: 36),
                        Expanded(child: copy),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: board),
                        copy,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _play(BuildContext context) async {
    final progress = AppScope.read(context).progress;
    if (progress.finishedAll) await progress.reset();
    if (!context.mounted) return;
    AnalyticsService.instance.logPlayTap(AppScope.read(context).progress.levelNumber);
    Navigator.of(context).pushNamed(AppRoutes.play);
  }
}
