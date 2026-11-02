// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Arrow Out';

  @override
  String get homeTagline => 'Quita todas las flechas.';

  @override
  String get play => 'Jugar';

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get howToLine => 'Toca una flecha con el camino libre.';

  @override
  String get skip => 'Saltar';

  @override
  String get back => 'Atrás';

  @override
  String get pause => 'Pausar';

  @override
  String get paused => 'Pausa';

  @override
  String get resume => 'Seguir';

  @override
  String get restart => 'Reiniciar';

  @override
  String get home => 'Inicio';

  @override
  String get hint => 'Pista';

  @override
  String get noHints => 'No quedan pistas';

  @override
  String get noHearts => 'Sin vidas';

  @override
  String get tryAgain => 'Otra vez';

  @override
  String get levelClear => 'Listo';

  @override
  String get nextLevel => 'Siguiente';

  @override
  String get noHeartsLost => 'Sin perder vidas';

  @override
  String get allClear => 'Todos los niveles están listos';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGame => 'Juego';

  @override
  String get settingsAbout => 'Información';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma del teléfono';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsReduceMotion => 'Reducir movimiento';

  @override
  String get settingsAccessibility => 'Accesibilidad';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Activado';

  @override
  String get motionOff => 'Desactivado';

  @override
  String get settingsShowTips => 'Mostrar cómo jugar otra vez';

  @override
  String get settingsTipsReset =>
      'Cómo jugar se mostrará la próxima vez que abras la app.';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get openFailed => 'No se pudo abrir la página.';

  @override
  String get arrowUp => 'Flecha arriba';

  @override
  String get arrowDown => 'Flecha abajo';

  @override
  String get arrowLeft => 'Flecha izquierda';

  @override
  String get arrowRight => 'Flecha derecha';

  @override
  String get arrowEither => 'Flecha de dos lados';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vidas',
      one: '1 vida',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
