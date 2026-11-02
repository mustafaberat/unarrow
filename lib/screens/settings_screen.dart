import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen(AnalyticsValues.settings);
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppScope.of(context).settings;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final lang = settings.language;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: l10n.back,
                  ),
                  Expanded(child: Text(l10n.settings, style: theme.titleLarge)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppDimens.maxContent),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppDimens.page, 8, AppDimens.page, 32),
                    children: [
                      _Section(l10n.settingsGeneral),
                      _Card(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.translate_rounded),
                            title: Text(l10n.settingsLanguage),
                            subtitle: Text(
                              lang == null ? l10n.settingsLanguageSystem : SettingsService.languageNames[lang]!,
                            ),
                            onTap: () => _pickLanguage(context),
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.volume_up_rounded),
                            title: Text(l10n.settingsSound),
                            value: settings.sound,
                            onChanged: settings.setSound,
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.vibration_rounded),
                            title: Text(l10n.settingsHaptics),
                            value: settings.haptics,
                            onChanged: settings.setHaptics,
                          ),
                        ],
                      ),
                      _Section(l10n.settingsAccessibility),
                      _Card(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.settingsReduceMotion, style: theme.titleMedium),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final choice in ReduceMotionPref.values)
                                      ChoiceChip(
                                        label: Text(_motionLabel(l10n, choice)),
                                        selected: settings.reduceMotion == choice,
                                        onSelected: (_) => settings.setReduceMotion(choice),
                                        selectedColor: AppColors.blue,
                                        backgroundColor: AppColors.background,
                                        checkmarkColor: AppColors.onAccent,
                                        labelStyle: TextStyle(
                                          color: settings.reduceMotion == choice
                                              ? AppColors.onAccent
                                              : AppColors.ink,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        side: const BorderSide(color: AppColors.line),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _Section(l10n.settingsGame),
                      _Card(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.help_outline_rounded),
                            title: Text(l10n.howToPlay),
                            onTap: () {
                              AnalyticsService.instance.logHowToPlayOpen(AnalyticsValues.settings);
                              Navigator.of(context).pushNamed(AppRoutes.howTo);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.replay_rounded),
                            title: Text(l10n.settingsShowTips),
                            onTap: () {
                              settings.setOnboardingDone(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.settingsTipsReset)),
                              );
                            },
                          ),
                        ],
                      ),
                      _Section(l10n.settingsAbout),
                      _Card(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.shield_outlined),
                            title: Text(l10n.settingsPrivacy),
                            trailing: const Icon(Icons.open_in_new_rounded),
                            onTap: () => _openPrivacy(context),
                          ),
                          const _VersionTile(),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Text(
                          '${l10n.appTitle} · ${l10n.developer}',
                          style: theme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _motionLabel(AppLocalizations l10n, ReduceMotionPref pref) => switch (pref) {
    ReduceMotionPref.system => l10n.motionSystem,
    ReduceMotionPref.on => l10n.motionOn,
    ReduceMotionPref.off => l10n.motionOff,
  };

  Future<void> _pickLanguage(BuildContext context) async {
    final settings = AppScope.read(context).settings;
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        Widget option(String? code, String label) {
          final selected = settings.language == code;
          return ListTile(
            title: Text(label),
            trailing: selected ? const Icon(Icons.check_rounded, color: AppColors.blue) : null,
            onTap: () {
              settings.setLanguage(code);
              Navigator.of(sheetContext).pop();
            },
          );
        }

        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              option(null, l10n.settingsLanguageSystem),
              for (final code in SettingsService.supportedLanguages)
                option(code, SettingsService.languageNames[code]!),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openPrivacy(BuildContext context) async {
    final opened = await launchUrl(Uri.parse(AppIdentity.privacyUrl), mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).openFailed)),
      );
    }
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Column(children: children),
    );
  }
}

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _version = '${info.version} (${info.buildNumber})');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline_rounded),
      title: Text(AppLocalizations.of(context).settingsVersion),
      trailing: Text(_version, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
