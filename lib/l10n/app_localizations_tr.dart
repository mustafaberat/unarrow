// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => 'Bütün okları çıkar.';

  @override
  String get play => 'Oyna';

  @override
  String levelLabel(int level) {
    return 'Seviye $level';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get howToPlay => 'Nasıl oynanır';

  @override
  String get howToLine => 'Yolu açık olan oka dokun.';

  @override
  String get skip => 'Geç';

  @override
  String get back => 'Geri';

  @override
  String get pause => 'Duraklat';

  @override
  String get paused => 'Duraklatıldı';

  @override
  String get resume => 'Devam';

  @override
  String get restart => 'Baştan';

  @override
  String get home => 'Ana sayfa';

  @override
  String get hint => 'İpucu';

  @override
  String get noHints => 'İpucu kalmadı';

  @override
  String get noHearts => 'Can kalmadı';

  @override
  String get tryAgain => 'Yeniden dene';

  @override
  String get levelClear => 'Bitti';

  @override
  String get nextLevel => 'Sonraki';

  @override
  String get noHeartsLost => 'Can kaybı yok';

  @override
  String get allClear => 'Bütün seviyeler bitti';

  @override
  String get playAgain => 'Yeniden oyna';

  @override
  String get settingsGeneral => 'Genel';

  @override
  String get settingsGame => 'Oyun';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Cihaz dili';

  @override
  String get settingsSound => 'Ses';

  @override
  String get settingsHaptics => 'Titreşim';

  @override
  String get settingsReduceMotion => 'Hareketi azalt';

  @override
  String get settingsAccessibility => 'Erişilebilirlik';

  @override
  String get motionSystem => 'Sistem';

  @override
  String get motionOn => 'Açık';

  @override
  String get motionOff => 'Kapalı';

  @override
  String get settingsShowTips => 'Nasıl oynanır yeniden gösterilsin';

  @override
  String get settingsTipsReset =>
      'Nasıl oynanır, uygulamayı yeniden açınca gösterilir.';

  @override
  String get settingsPrivacy => 'Gizlilik politikası';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get openFailed => 'Sayfa açılmadı.';

  @override
  String get arrowUp => 'Yukarı ok';

  @override
  String get arrowDown => 'Aşağı ok';

  @override
  String get arrowLeft => 'Sol ok';

  @override
  String get arrowRight => 'Sağ ok';

  @override
  String get arrowEither => 'İki yönlü ok';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count can',
      one: '1 can',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
