// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => '矢印をすべて出そう。';

  @override
  String get play => 'プレイ';

  @override
  String levelLabel(int level) {
    return 'レベル $level';
  }

  @override
  String get settings => '設定';

  @override
  String get howToPlay => '遊び方';

  @override
  String get howToLine => '道が空いている矢印をタップ。';

  @override
  String get skip => 'スキップ';

  @override
  String get back => '戻る';

  @override
  String get pause => '一時停止';

  @override
  String get paused => '一時停止';

  @override
  String get resume => '続ける';

  @override
  String get restart => '最初から';

  @override
  String get home => 'ホーム';

  @override
  String get hint => 'ヒント';

  @override
  String get noHints => 'ヒントがありません';

  @override
  String get noHearts => 'ハートがありません';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get levelClear => 'クリア';

  @override
  String get nextLevel => '次へ';

  @override
  String get noHeartsLost => 'ハートはそのまま';

  @override
  String get allClear => 'すべてのレベルをクリア';

  @override
  String get playAgain => 'もう一度遊ぶ';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsGame => 'ゲーム';

  @override
  String get settingsAbout => '情報';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => '端末の言語';

  @override
  String get settingsSound => '音';

  @override
  String get settingsHaptics => '振動';

  @override
  String get settingsReduceMotion => '動きを減らす';

  @override
  String get settingsAccessibility => 'アクセシビリティ';

  @override
  String get motionSystem => 'システム';

  @override
  String get motionOn => 'オン';

  @override
  String get motionOff => 'オフ';

  @override
  String get settingsShowTips => '遊び方をもう一度表示';

  @override
  String get settingsTipsReset => '次にアプリを開くと、遊び方が出ます。';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get openFailed => 'ページを開けませんでした。';

  @override
  String get arrowUp => '上向きの矢印';

  @override
  String get arrowDown => '下向きの矢印';

  @override
  String get arrowLeft => '左向きの矢印';

  @override
  String get arrowRight => '右向きの矢印';

  @override
  String get arrowEither => '両方向の矢印';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ハート $count',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
