import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics/analytics_service.dart';
import 'app_scope.dart';
import 'config/app_theme.dart';
import 'config/tokens.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/play_screen.dart';
import 'screens/settings_screen.dart';
import 'services/progress_store.dart';
import 'services/settings_service.dart';
import 'config/app_config.dart';

class ArrowOutApp extends StatelessWidget {
  const ArrowOutApp({required this.services, this.home, super.key});

  final AppServices services;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: services.settings,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.current,
          locale: services.settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: _resolveLocale,
          builder: (context, child) {
            return AppScope(services: services, child: child ?? const SizedBox.shrink());
          },
          home: home ?? const HomeScreen(),
          onGenerateRoute: _route,
        );
      },
    );
  }

  static Locale _resolveLocale(Locale? device, Iterable<Locale> supported) {
    if (device != null) {
      for (final locale in supported) {
        if (locale.languageCode == device.languageCode) return locale;
      }
    }
    return const Locale('en');
  }

  static Route<void> _route(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.settings => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SettingsScreen(),
      ),
      AppRoutes.howTo => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => HowToPlayScreen(firstRun: settings.arguments == true),
      ),
      AppRoutes.play => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const PlayScreen(),
      ),
      _ => MaterialPageRoute<void>(settings: settings, builder: (_) => const HomeScreen()),
    };
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await _guarded(
    'orientation',
    () => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  );

  SettingsService? settings;
  await _guarded('settings', () async {
    settings = await SettingsService.create();
  });
  settings ??= await _inMemorySettings();
  final progress = ProgressStore(settings!.prefs);
  runApp(ArrowOutApp(services: AppServices(settings: settings!, progress: progress)));
  unawaited(AnalyticsService.instance.start(settings!.prefs).catchError((Object _) {}));
}

Future<void> _guarded(String label, Future<void> Function() step) async {
  try {
    await step().timeout(AppMotion.startup);
  } catch (error, stack) {
    debugPrint('startup $label failed: $error\n$stack');
  }
}

Future<SettingsService> _inMemorySettings() async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return SettingsService(await SharedPreferences.getInstance());
}
