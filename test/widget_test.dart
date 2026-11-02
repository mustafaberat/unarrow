import 'package:flutter/material.dart';

import 'package:arrow_out/app.dart';
import 'package:arrow_out/app_scope.dart';
import 'package:arrow_out/services/progress_store.dart';
import 'package:arrow_out/services/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppServices> services() async {
    final settings = SettingsService(await SharedPreferences.getInstance());
    await settings.setLanguage('en');
    return AppServices(settings: settings, progress: ProgressStore(settings.prefs));
  }

  testWidgets('first open plays the lesson', (tester) async {
    await tester.pumpWidget(ArrowOutApp(services: await services()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Tap an arrow with a clear path.'), findsOneWidget);
  });

  testWidgets('skip then play opens level 1', (tester) async {
    await tester.pumpWidget(ArrowOutApp(services: await services()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Skip'), findsNothing);
    expect(find.text('Clear every arrow.'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Play'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byTooltip('Pause'), findsOneWidget);
  });
}
