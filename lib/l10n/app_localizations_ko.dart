// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => '화살표를 모두 빼세요.';

  @override
  String get play => '플레이';

  @override
  String levelLabel(int level) {
    return '레벨 $level';
  }

  @override
  String get settings => '설정';

  @override
  String get howToPlay => '플레이 방법';

  @override
  String get howToLine => '길이 빈 화살표를 누르세요.';

  @override
  String get skip => '건너뛰기';

  @override
  String get back => '뒤로';

  @override
  String get pause => '일시 정지';

  @override
  String get paused => '일시정지';

  @override
  String get resume => '계속';

  @override
  String get restart => '다시 시작';

  @override
  String get home => '홈';

  @override
  String get hint => '힌트';

  @override
  String get noHints => '힌트가 없습니다';

  @override
  String get noHearts => '하트가 없습니다';

  @override
  String get tryAgain => '다시 하기';

  @override
  String get levelClear => '클리어';

  @override
  String get nextLevel => '다음';

  @override
  String get noHeartsLost => '하트를 잃지 않았어요';

  @override
  String get allClear => '모든 레벨을 깼어요';

  @override
  String get playAgain => '다시 플레이';

  @override
  String get settingsGeneral => '일반';

  @override
  String get settingsGame => '게임';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '기기 언어';

  @override
  String get settingsSound => '소리';

  @override
  String get settingsHaptics => '진동';

  @override
  String get settingsReduceMotion => '움직임 줄이기';

  @override
  String get settingsAccessibility => '접근성';

  @override
  String get motionSystem => '시스템';

  @override
  String get motionOn => '켜기';

  @override
  String get motionOff => '끄기';

  @override
  String get settingsShowTips => '플레이 방법 다시 보기';

  @override
  String get settingsTipsReset => '다음에 앱을 열면 플레이 방법이 나옵니다.';

  @override
  String get settingsPrivacy => '개인정보 처리방침';

  @override
  String get settingsVersion => '버전';

  @override
  String get openFailed => '페이지를 열 수 없습니다.';

  @override
  String get arrowUp => '위 화살표';

  @override
  String get arrowDown => '아래 화살표';

  @override
  String get arrowLeft => '왼쪽 화살표';

  @override
  String get arrowRight => '오른쪽 화살표';

  @override
  String get arrowEither => '양방향 화살표';

  @override
  String hearts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '하트 $count개',
    );
    return '$_temp0';
  }

  @override
  String get developer => 'ARU Soft';
}
