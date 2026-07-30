import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/diagnostics_service.dart';
import '../i18n/strings.g.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final DiagnosticsService _service = DiagnosticsService.instance;
  String? _logcatOutput;
  bool _loadingLogcat = false;

  @override
  void initState() {
    super.initState();
    _fetchLogcat();
  }

  Future<void> _fetchLogcat() async {
    setState(() => _loadingLogcat = true);
    final logcat = await _service.fetchLogcat();
    if (mounted) {
      setState(() {
        _logcatOutput = logcat;
        _loadingLogcat = false;
      });
    }
  }

  void _clearLogs() {
    setState(() {
      _service.clear();
      _logcatOutput = null;
    });
  }

  void _copyLogs() {
    final sb = StringBuffer();
    sb.writeln(_service.exportAsText());

    if (_logcatOutput != null && _logcatOutput!.isNotEmpty) {
      sb.writeln();
      sb.writeln('=== Logcat ===');
      sb.writeln(_logcatOutput);
    }

    final text = sb.toString();
    if (text.trim().isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.settings_screen.diagnostics_copied)),
    );
  }

  Color _getLevelColor(LogLevel level, ColorScheme colorScheme) {
    switch (level) {
      case LogLevel.info:
        return colorScheme.primary;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return colorScheme.error;
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warning:
        return Icons.warning_amber_rounded;
      case LogLevel.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!DiagnosticsService.isEnabled) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t.settings_screen.diagnostics_app_bar),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bug_report_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  t.settings_screen.diagnostics_disabled,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final entries = _service.entries.reversed.toList(); // Mới nhất lên đầu

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_screen.diagnostics_app_bar),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: t.settings_screen.diagnostics_copy,
            onPressed: (entries.isEmpty && (_logcatOutput == null || _logcatOutput!.isEmpty))
                ? null
                : _copyLogs,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: t.settings_screen.diagnostics_clear,
            onPressed: entries.isEmpty ? null : _clearLogs,
          ),
        ],
      ),
      body: entries.isEmpty && !_loadingLogcat && (_logcatOutput == null || _logcatOutput!.isEmpty)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bug_report_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.settings_screen.diagnostics_empty,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchLogcat,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  // Danh sách các entry từ DiagnosticsService
                  if (entries.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'App Logs (${entries.length})',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    ...entries.map((entry) => _buildEntryTile(entry, theme, colorScheme)),
                  ],
                  // Logcat output
                  if (_loadingLogcat)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_logcatOutput != null && _logcatOutput!.isNotEmpty) ...[
                    const Divider(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Logcat',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _fetchLogcat,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: SelectableText(
                        _logcatOutput!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEntryTile(
    DiagnosticEntry entry,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final levelColor = _getLevelColor(entry.level, colorScheme);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        leading: Icon(
          _getLevelIcon(entry.level),
          color: levelColor,
          size: 22,
        ),
        title: Text(
          entry.message,
          style: theme.textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${entry.levelLabel} • ${entry.source} • ${entry.formattedTime}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        children: [
          if (entry.stackTrace != null && entry.stackTrace!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SelectableText(
                entry.stackTrace!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
