// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => 'Togli tutte le frecce.';

  @override
  String get play => 'Gioca';

  @override
  String levelLabel(int level) {
    return 'Livello $level';
  }

  @override
  String get settings => 'Impostazioni';

  @override
  String get howToPlay => 'Come si gioca';

  @override
  String get howToLine => 'Tocca una freccia con la via libera.';

  @override
  String get skip => 'Salta';

  @override
  String get back => 'Indietro';

  @override
  String get pause => 'Pausa';

  @override
  String get paused => 'Pausa';

  @override
  String get resume => 'Riprendi';

  @override
  String get restart => 'Ricomincia';

  @override
  String get home => 'Home';

  @override
  String get hint => 'Suggerimento';

  @override
  String get noHints => 'Nessun suggerimento';

  @override
  String get noHearts => 'Nessuna vita';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get levelClear => 'Fatto';

  @override
  String get nextLevel => 'Avanti';

  @override
  String get noHeartsLost => 'Nessuna vita persa';

  @override
  String get allClear => 'Tutti i livelli sono fatti';

  @override
  String get playAgain => 'Gioca di nuovo';

  @override
  String get settingsGeneral => 'Generale';

  @override
  String get settingsGame => 'Gioco';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Lingua del dispositivo';

  @override
  String get settingsSound => 'Suono';

  @override
  String get settingsHaptics => 'Vibrazione';

  @override
  String get settingsReduceMotion => 'Riduci il movimento';

  @override
  String get settingsAccessibility => 'Accessibilità';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Attivo';

  @override
  String get motionOff => 'Spento';

  @override
  String get settingsShowTips => 'Mostra di nuovo come si gioca';

  @override
  String get settingsTipsReset =>
      'La guida si apre la prossima volta che apri l\'app.';

  @override
  String get settingsPrivacy => 'Informativa privacy';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get openFailed => 'La pagina non si è aperta.';

  @override
  String get arrowUp => 'Freccia in su';

  @override
  String get arrowDown => 'Freccia in giù';

  @override
  String get arrowLeft => 'Freccia a sinistra';

  @override
  String get arrowRight => 'Freccia a destra';

  @override
  String get arrowEither => 'Freccia nei due versi';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vite',
      one: '1 vita',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
