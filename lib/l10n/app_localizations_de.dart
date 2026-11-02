// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => 'Nimm alle Pfeile weg.';

  @override
  String get play => 'Spielen';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get howToPlay => 'Anleitung';

  @override
  String get howToLine => 'Tippe einen Pfeil mit freiem Weg.';

  @override
  String get skip => 'Überspringen';

  @override
  String get back => 'Zurück';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Pause';

  @override
  String get resume => 'Weiter';

  @override
  String get restart => 'Neu starten';

  @override
  String get home => 'Start';

  @override
  String get hint => 'Hinweis';

  @override
  String get noHints => 'Keine Hinweise mehr';

  @override
  String get noHearts => 'Keine Herzen mehr';

  @override
  String get tryAgain => 'Nochmal';

  @override
  String get levelClear => 'Geschafft';

  @override
  String get nextLevel => 'Weiter';

  @override
  String get noHeartsLost => 'Kein Herz verloren';

  @override
  String get allClear => 'Alle Level sind geschafft';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsGame => 'Spiel';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Sprache des Geräts';

  @override
  String get settingsSound => 'Ton';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsReduceMotion => 'Weniger Bewegung';

  @override
  String get settingsAccessibility => 'Barrierefreiheit';

  @override
  String get motionSystem => 'System';

  @override
  String get motionOn => 'An';

  @override
  String get motionOff => 'Aus';

  @override
  String get settingsShowTips => 'Anleitung erneut zeigen';

  @override
  String get settingsTipsReset =>
      'Die Anleitung kommt beim nächsten Öffnen der App.';

  @override
  String get settingsPrivacy => 'Datenschutz';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'Die Seite konnte nicht geöffnet werden.';

  @override
  String get arrowUp => 'Pfeil nach oben';

  @override
  String get arrowDown => 'Pfeil nach unten';

  @override
  String get arrowLeft => 'Pfeil nach links';

  @override
  String get arrowRight => 'Pfeil nach rechts';

  @override
  String get arrowEither => 'Pfeil in beide Richtungen';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Herzen',
      one: '1 Herz',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
