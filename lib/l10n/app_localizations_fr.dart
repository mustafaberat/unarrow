// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Arrow Out';

  @override
  String get homeTagline => 'Enlève toutes les flèches.';

  @override
  String get play => 'Jouer';

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String get settings => 'Réglages';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get howToLine => 'Touche une flèche dont le chemin est libre.';

  @override
  String get skip => 'Passer';

  @override
  String get back => 'Retour';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get restart => 'Recommencer';

  @override
  String get home => 'Accueil';

  @override
  String get hint => 'Indice';

  @override
  String get noHints => 'Plus d\'indices';

  @override
  String get noHearts => 'Plus de vies';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get levelClear => 'Réussi';

  @override
  String get nextLevel => 'Suivant';

  @override
  String get noHeartsLost => 'Aucune vie perdue';

  @override
  String get allClear => 'Tous les niveaux sont finis';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsGame => 'Jeu';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue de l\'appareil';

  @override
  String get settingsSound => 'Son';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsReduceMotion => 'Réduire les animations';

  @override
  String get settingsAccessibility => 'Accessibilité';

  @override
  String get motionSystem => 'Système';

  @override
  String get motionOn => 'Activé';

  @override
  String get motionOff => 'Désactivé';

  @override
  String get settingsShowTips => 'Revoir comment jouer';

  @override
  String get settingsTipsReset => 'Le guide revient à la prochaine ouverture.';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'La page ne s\'est pas ouverte.';

  @override
  String get arrowUp => 'Flèche vers le haut';

  @override
  String get arrowDown => 'Flèche vers le bas';

  @override
  String get arrowLeft => 'Flèche vers la gauche';

  @override
  String get arrowRight => 'Flèche vers la droite';

  @override
  String get arrowEither => 'Flèche des deux côtés';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vies',
      one: '1 vie',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
