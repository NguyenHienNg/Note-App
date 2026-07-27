import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../models/note.dart';
import '../i18n/strings.g.dart';
import 'theme_color_screen.dart';

class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({super.key});

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? subtitle,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(t.settings_screen.advanced_settings_app_bar),
            const SizedBox(width: 8),
            Container(
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
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            _buildSettingsItem(
              context,
              title: t.settings_screen.animations_title,
              subtitle: t.settings_screen.animations_subtitle,
              trailing: Switch(
                value: themeProvider.enableAnimations,
                onChanged: (bool value) {
                  themeProvider.setEnableAnimations(value);
                },
              ),
              onTap: () {
                themeProvider.setEnableAnimations(
                  !themeProvider.enableAnimations,
                );
              },
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.theme_color_title,
              subtitle: ThemeColorScreen.getThemeColorName(
                themeProvider.themeColor,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/advanced/color'),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.backup_title,
              subtitle: t.settings_screen.backup_subtitle,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/advanced/backup'),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.restore_title,
              subtitle: t.settings_screen.restore_subtitle,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _handleRestore(context),
            ),
            _buildSettingsItem(
              context,
              title: t.settings_screen.diagnostics_title,
              subtitle: t.settings_screen.diagnostics_subtitle,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/advanced/diagnostics'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.settings_screen.advanced_footer_note,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Mở file picker để chọn file backup, rồi parse và navigate
  Future<void> _handleRestore(BuildContext context) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt', 'zip', 'tar'],
      );

      if (result == null || result.files.isEmpty) return;
      if (!context.mounted) return;

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final fileName = result.files.single.name.toLowerCase();

      List<Note> parsedNotes = [];

      if (fileName.endsWith('.zip')) {
        final archive = ZipDecoder().decodeBytes(bytes);
        for (final entry in archive) {
          if (entry.isFile && entry.name.endsWith('.json')) {
            final content = utf8.decode(entry.content as List<int>);
            parsedNotes.addAll(_parseJsonContent(content));
          }
        }
      } else if (fileName.endsWith('.tar')) {
        final archive = TarDecoder().decodeBytes(bytes);
        for (final entry in archive) {
          if (entry.isFile && entry.name.endsWith('.json')) {
            final content = utf8.decode(entry.content as List<int>);
            parsedNotes.addAll(_parseJsonContent(content));
          }
        }
      } else {
        // .json or .txt
        final content = utf8.decode(bytes);
        parsedNotes = _parseJsonContent(content);
      }

      if (!context.mounted) return;

      if (parsedNotes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.settings_screen.restore_no_notes)),
        );
        return;
      }

      if (parsedNotes.length == 1) {
        // File đơn lẻ → đi thẳng vào RestoreScreen
        context.push('/settings/advanced/restore/confirm', extra: parsedNotes);
      } else {
        // Nhiều ghi chú → đi vào RestoreSelectScreen
        context.push('/settings/advanced/restore/select', extra: parsedNotes);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.settings_screen.restore_file_error),
        ),
      );
    }
  }

  /// Parse nội dung JSON thành danh sách Note
  static List<Note> _parseJsonContent(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        // Một ghi chú đơn
        return [Note.fromMap(decoded)];
      } else if (decoded is List) {
        // Danh sách ghi chú
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((m) => Note.fromMap(m))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
