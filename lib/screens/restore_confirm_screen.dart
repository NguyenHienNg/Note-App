import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../i18n/strings.g.dart';

class RestoreScreen extends StatefulWidget {
  final List<Note> notes;

  const RestoreScreen({super.key, required this.notes});

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  int _currentIndex = 0;
  bool _hasRestoredAny = false;

  Note get _currentNote => widget.notes[_currentIndex];

  bool get _hasConflict {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return noteProvider.hasNoteWithCreatedAt(_currentNote.createdAt);
  }

  void _handleReplace() {
    _hasRestoredAny = true;
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final existing = noteProvider.findNoteByCreatedAt(_currentNote.createdAt);
    if (existing != null) {
      noteProvider.replaceNote(existing.id, _currentNote);
    }
    _moveNext();
  }

  void _handleRename() {
    _hasRestoredAny = true;
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final suffix = noteProvider.getNextRenameSuffix(_currentNote.title);
    final renamedNote = Note(
      id: DateTime.now().toString(),
      title: '${_currentNote.title} ($suffix)',
      content: _currentNote.content,
      createdAt: DateTime.now(), // Tạo thời gian mới
    );
    noteProvider.addNoteFromBackup(renamedNote);
    _moveNext();
  }

  void _handleConfirm() {
    _hasRestoredAny = true;
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    noteProvider.addNoteFromBackup(
      Note(
        id: _currentNote.id,
        title: _currentNote.title,
        content: _currentNote.content,
        createdAt: _currentNote.createdAt,
      ),
    );
    _moveNext();
  }

  void _handleCancel() {
    // Bỏ qua ghi chú này và chuyển sang ghi chú tiếp theo
    _moveNext();
  }

  Future<void> _handleExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 24.0,
        ),
        title: Text(t.settings_screen.restore_cancel_dialog_title),
        content: SizedBox(
          width: double.maxFinite,
          child: Text(t.settings_screen.restore_cancel_dialog_content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.settings_screen.restore_btn_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.settings_screen.restore_btn_confirm),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      context.go('/settings/advanced');
    }
  }

  void _moveNext() {
    if (_currentIndex + 1 < widget.notes.length) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Chỉ hiện SnackBar nếu có ít nhất 1 ghi chú được khôi phục
      if (_hasRestoredAny) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.settings_screen.restore_success)),
        );
      }
      context.go('/settings/advanced');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasConflict = _hasConflict;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleExit();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(t.settings_screen.restore_screen_title),
          automaticallyImplyLeading: false,
          // Hiển thị tiến trình nếu nhiều ghi chú
          bottom: widget.notes.length > 1
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: (_currentIndex + 1) / widget.notes.length,
                    ),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(value: value);
                    },
                  ),
                )
              : null,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon ghi chú
                Icon(
                  Icons.note_alt_outlined,
                  size: 72,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                // Tên ghi chú
                Text(
                  _currentNote.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Thời gian
                Text(
                  DateFormat.yMMMd(
                    LocaleSettings.currentLocale.languageCode,
                  ).add_jm().format(_currentNote.createdAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Thông báo
                Text(
                  t.settings_screen.restore_confirm_message,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                // Nếu nhiều ghi chú, hiển thị tiến trình
                if (widget.notes.length > 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_currentIndex + 1} / ${widget.notes.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nút Thay thế — chỉ khi có trùng createdAt
                    FilledButton.tonal(
                      onPressed: hasConflict ? _handleReplace : null,
                      child: Text(t.settings_screen.restore_btn_replace),
                    ),
                    const SizedBox(width: 12),
                    // Nút Đổi tên — chỉ khi có trùng createdAt
                    FilledButton.tonal(
                      onPressed: hasConflict ? _handleRename : null,
                      child: Text(t.settings_screen.restore_btn_rename),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nút Đúng — chỉ khi KHÔNG trùng
                    FilledButton(
                      onPressed: hasConflict ? null : _handleConfirm,
                      child: Text(t.settings_screen.restore_btn_confirm),
                    ),
                    const SizedBox(width: 12),
                    // Nút Hủy — luôn hoạt động
                    OutlinedButton(
                      onPressed: _handleCancel,
                      child: Text(t.settings_screen.restore_btn_cancel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
