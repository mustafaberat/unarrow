// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => 'Clear every arrow.';

  @override
  String get play => 'Play';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get settings => 'Settings';

  @override
  String get howToPlay => 'How to play';

  @override
  String get howToLine => 'Tap an arrow with a clear path.';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get home => 'Home';

  @override
  String get hint => 'Hint';

  @override
  String get noHints => 'No hints left';

  @override
  String get noHearts => 'No hearts left';

  @override
  String get tryAgain => 'Try again';

  @override
  String get levelClear => 'Clear';

  @override
  String get nextLevel => 'Next';

  @override
  String get noHeartsLost => 'No hearts lost';

  @override
  String get allClear => 'Every level is clear';

  @override
  String get playAgain => 'Play again';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGame => 'Game';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Device language';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get motionSystem => 'System';

  @override
  String get motionOn => 'On';

  @override
  String get motionOff => 'Off';

  @override
  String get settingsShowTips => 'Show how to play again';

  @override
  String get settingsTipsReset =>
      'How to play will show the next time you open the app.';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'Could not open the page.';

  @override
  String get arrowUp => 'Up arrow';

  @override
  String get arrowDown => 'Down arrow';

  @override
  String get arrowLeft => 'Left arrow';

  @override
  String get arrowRight => 'Right arrow';

  @override
  String get arrowEither => 'Arrow either way';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hearts',
      one: '1 heart',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
