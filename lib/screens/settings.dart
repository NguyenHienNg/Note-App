import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../i18n/strings.g.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Uri _githubUrl = Uri.parse('https://github.com/Dancycat/Notes-App');
  String _selectedLanguageCode = gAppLanguageCode;
  bool _showTooltip = false;
  bool _tooltipVisible = false;

  @override
  void initState() {
    super.initState();
    _loadTooltipState();
  }

  void _loadTooltipState() async {
    final prefs = await SharedPreferences.getInstance();
    final isDismissed = prefs.getBool('settings_tooltip_dismissed') ?? false;
    if (!mounted) return;
    if (!isDismissed) {
      setState(() {
        _showTooltip = true;
      });
      // Chờ 50ms cho khung hình đầu tiên dựng opacity = 0.0, sau đó kích hoạt mờ hiện từ từ
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _tooltipVisible = true;
        });
      }
    }
  }

  void _dismissTooltip() async {
    setState(() {
      _tooltipVisible = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_tooltip_dismissed', true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showTooltip = false;
        });
      }
    });
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot open link: $url')));
    }
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return RadioGroup<String>(
          groupValue: _selectedLanguageCode,
          onChanged: (String? value) async {
            if (value != null) {
              gAppLanguageCode = value;
              setState(() => _selectedLanguageCode = value);
              if (value == 'sys') {
                String deviceLang = WidgetsBinding
                    .instance
                    .platformDispatcher
                    .locale
                    .languageCode;
                if (deviceLang != 'vi' && deviceLang != 'en') deviceLang = 'en';
                LocaleSettings.setLocale(
                  deviceLang == 'vi' ? AppLocale.vi : AppLocale.en,
                );
              } else {
                LocaleSettings.setLocale(
                  value == 'vi' ? AppLocale.vi : AppLocale.en,
                );
              }
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('app_language', value);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t.settings_screen.language_selection_sheet_title,
                  style: Theme.of(ctx).textTheme.headlineSmall,
                ),
              ),
              RadioListTile<String>(
                title: Text(t.settings_screen.language_system),
                value: 'sys',
              ),
              RadioListTile<String>(
                title: Text(t.settings_screen.language_vietnamese),
                value: 'vi',
              ),
              RadioListTile<String>(
                title: Text(t.settings_screen.language_english),
                value: 'en',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'sys':
        return t.settings_screen.language_system;
      case 'vi':
        return t.settings_screen.language_vietnamese;
      case 'en':
        return t.settings_screen.language_english;
      default:
        return t.settings_screen.unknown;
    }
  }

  // FIX: Cache textTheme + colorScheme trong method thay vì gọi Theme.of() nhiều lần
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: leading != null
            ? IconTheme(
                data: IconThemeData(color: colorScheme.onSurfaceVariant),
                child: leading,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showThemeSelectionSheet(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return RadioGroup<ThemeMode>(
          groupValue: themeProvider.themeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              themeProvider.setThemeMode(value);
              Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t.settings_screen.theme_selection_sheet_title,
                  style: Theme.of(ctx).textTheme.headlineSmall,
                ),
              ),
              RadioListTile<ThemeMode>(
                title: Text(t.settings_screen.theme_system),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text(t.settings_screen.theme_light),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text(t.settings_screen.theme_dark),
                value: ThemeMode.dark,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return t.settings_screen.theme_system;
      case ThemeMode.light:
        return t.settings_screen.theme_light;
      case ThemeMode.dark:
        return t.settings_screen.theme_dark;
    }
  }

  Widget _buildRichTooltipCard(BuildContext context) {
    if (!_showTooltip) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _tooltipVisible ? 1.0 : 0.0,
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.settings_screen.tooltip_title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: t.settings_screen.tooltip_prefix,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: t.settings_screen.tooltip_highlight,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      TextSpan(text: t.settings_screen.tooltip_suffix),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _dismissTooltip,
                    child: Text(t.settings_screen.tooltip_btn_got_it),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings_screen.app_bar_title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          children: [
            _buildRichTooltipCard(context),
            const SizedBox(height: 8.0),
            _buildSectionHeader(context, t.settings_screen.section_appearance),
            const SizedBox(height: 8.0),
            _buildSettingsItem(
              context,
              title: t.settings_screen.theme_title,
              subtitle: _getThemeModeName(themeProvider.themeMode),
              leading: const Icon(Icons.contrast),
              onTap: () => _showThemeSelectionSheet(context, themeProvider),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.language_title,
              subtitle: _getLanguageName(_selectedLanguageCode),
              leading: const Icon(Icons.language_outlined),
              onTap: () => _showLanguageSelectionSheet(context),
            ),
            const Divider(height: 0, thickness: 1.5),
            const SizedBox(height: 16.0),
            _buildSectionHeader(context, t.settings_screen.section_about),
            const SizedBox(height: 12.0),
            _buildSettingsItem(
              context,
              title: t.settings_screen.view_source_title,
              subtitle: t.settings_screen.view_source_subtitle,
              leading: const Icon(Icons.code_outlined),
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.check_update_title,
              leading: const Icon(Icons.update),
              onTap: () => context.push('/settings/update'),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.about_app_title,
              leading: const Icon(Icons.info_outline),
              onTap: () => context.push('/settings/about'),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.section_advanced,
              leading: const Icon(Icons.tune_outlined),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'BETA',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => context.push('/settings/advanced'),
            ),
          ],
        ),
      ),
    );
  }
}
