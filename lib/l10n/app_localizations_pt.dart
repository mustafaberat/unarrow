// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Unarrow';

  @override
  String get homeTagline => 'Tire todas as flechas.';

  @override
  String get play => 'Jogar';

  @override
  String levelLabel(int level) {
    return 'Nível $level';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get howToLine => 'Toque na flecha com o caminho livre.';

  @override
  String get skip => 'Pular';

  @override
  String get back => 'Voltar';

  @override
  String get pause => 'Pausar';

  @override
  String get paused => 'Pausado';

  @override
  String get resume => 'Continuar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get home => 'Início';

  @override
  String get hint => 'Dica';

  @override
  String get noHints => 'Sem dicas';

  @override
  String get noHearts => 'Sem vidas';

  @override
  String get tryAgain => 'De novo';

  @override
  String get levelClear => 'Pronto';

  @override
  String get nextLevel => 'Próximo';

  @override
  String get noHeartsLost => 'Nenhuma vida perdida';

  @override
  String get allClear => 'Todos os níveis estão prontos';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsGame => 'Jogo';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma do celular';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsHaptics => 'Vibração';

  @override
  String get settingsReduceMotion => 'Reduzir movimento';

  @override
  String get settingsAccessibility => 'Acessibilidade';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Ativado';

  @override
  String get motionOff => 'Desativado';

  @override
  String get settingsShowTips => 'Mostrar como jogar de novo';

  @override
  String get settingsTipsReset =>
      'Como jogar vai aparecer na próxima vez que você abrir o app.';

  @override
  String get settingsPrivacy => 'Política de privacidade';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get openFailed => 'Não foi possível abrir a página.';

  @override
  String get arrowUp => 'Seta para cima';

  @override
  String get arrowDown => 'Seta para baixo';

  @override
  String get arrowLeft => 'Seta para a esquerda';

  @override
  String get arrowRight => 'Seta para a direita';

  @override
  String get arrowEither => 'Seta dos dois lados';

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
