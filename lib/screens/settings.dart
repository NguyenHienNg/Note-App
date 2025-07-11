import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import 'about_app_screen.dart';
import '../i18n/strings.g.dart';

// Chuyển SettingsScreen thành StatefulWidget để quản lý trạng thái ngôn ngữ
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Uri _githubUrl = Uri.parse('https://github.com/NguyenHienNg/Notes-App');
  // Giá trị ngôn ngữ được chọn: có thể là "en", "vi", hoặc "sys" (mặc định hệ thống)
  String _selectedLanguageCode = "sys";

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  // Hàm tải ngôn ngữ đã chọn từ SharedPreferences
  void _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('app_language');
    setState(() {
      _selectedLanguageCode = savedLang ?? 'sys';
    });
    // Nếu lưu là hệ thống, lấy ngôn ngữ của hệ thống
    if (_selectedLanguageCode == 'sys') {
      String deviceLang = window.locale.languageCode;
      if (deviceLang != 'vi' && deviceLang != 'en') {
        deviceLang = 'en';
      }
      if (deviceLang == 'vi') {
        LocaleSettings.setLocale(AppLocale.vi);
      } else {
        LocaleSettings.setLocale(AppLocale.en);
      }
    } else {
      // Nếu lưu là "vi" hoặc "en"
      if (_selectedLanguageCode == 'vi') {
        LocaleSettings.setLocale(AppLocale.vi);
      } else {
        LocaleSettings.setLocale(AppLocale.en);
      }
    }
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open link: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm hiển thị sheet chọn ngôn ngữ
  void _showLanguageSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
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
              title: Text(t.settings_screen.language_system), // Bạn cần đảm bảo đã thêm chuỗi này vào strings.g.dart
              value: 'sys',
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  // Lấy ngôn ngữ của hệ thống
                  String deviceLang = window.locale.languageCode;
                  if (deviceLang != 'vi' && deviceLang != 'en') {
                    deviceLang = 'en';
                  }
                  if (deviceLang == 'vi') {
                    LocaleSettings.setLocale(AppLocale.vi);
                  } else {
                    LocaleSettings.setLocale(AppLocale.en);
                  }
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('app_language', value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(t.settings_screen.language_vietnamese),
              value: 'vi',
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  LocaleSettings.setLocale(AppLocale.vi);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('app_language', value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(t.settings_screen.language_english),
              value: 'en',
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  LocaleSettings.setLocale(AppLocale.en);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('app_language', value);
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // Hàm helper để lấy tên hiển thị ngôn ngữ dựa trên code
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showThemeSelectionSheet(
      BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
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
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings_screen.theme_light),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings_screen.theme_dark),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_screen.app_bar_title),
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          children: [
            const SizedBox(height: 8.0),
            _buildSectionHeader(context, t.settings_screen.section_appearance),
            const SizedBox(height: 8.0),
            _buildSettingsItem(
              context,
              title: t.settings_screen.theme_title,
              subtitle: _getThemeModeName(themeProvider.themeMode),
              onTap: () => _showThemeSelectionSheet(context, themeProvider),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.language_title,
              subtitle: _getLanguageName(_selectedLanguageCode),
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
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.help_translate_title,
              subtitle: t.settings_screen.help_translate_subtitle,
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.report_bug_title,
              subtitle: t.settings_screen.report_bug_subtitle,
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.about_app_title,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutAppScreen()),
                );
              },
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}