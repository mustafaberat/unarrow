// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => '清掉所有箭头。';

  @override
  String get play => '开始';

  @override
  String levelLabel(int level) {
    return '第 $level 关';
  }

  @override
  String get settings => '设置';

  @override
  String get howToPlay => '怎么玩';

  @override
  String get howToLine => '点一条前方是空的箭头。';

  @override
  String get skip => '跳过';

  @override
  String get back => '返回';

  @override
  String get pause => '暂停';

  @override
  String get paused => '已暂停';

  @override
  String get resume => '继续';

  @override
  String get restart => '重来';

  @override
  String get home => '主页';

  @override
  String get hint => '提示';

  @override
  String get noHints => '没有提示了';

  @override
  String get noHearts => '没有心了';

  @override
  String get tryAgain => '再试一次';

  @override
  String get levelClear => '过关';

  @override
  String get nextLevel => '下一关';

  @override
  String get noHeartsLost => '没有丢心';

  @override
  String get allClear => '全部关卡都过了';

  @override
  String get playAgain => '再玩一次';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsGame => '游戏';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '设备语言';

  @override
  String get settingsSound => '声音';

  @override
  String get settingsHaptics => '振动';

  @override
  String get settingsReduceMotion => '减少动画';

  @override
  String get settingsAccessibility => '辅助功能';

  @override
  String get motionSystem => '系统';

  @override
  String get motionOn => '开';

  @override
  String get motionOff => '关';

  @override
  String get settingsShowTips => '再次显示怎么玩';

  @override
  String get settingsTipsReset => '下次打开应用时会显示怎么玩。';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsVersion => '版本';

  @override
  String get openFailed => '页面打不开。';

  @override
  String get arrowUp => '向上的箭头';

  @override
  String get arrowDown => '向下的箭头';

  @override
  String get arrowLeft => '向左的箭头';

  @override
  String get arrowRight => '向右的箭头';

  @override
  String get arrowEither => '双向箭头';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 颗心',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
