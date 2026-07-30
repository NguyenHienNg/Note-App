import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../i18n/strings.g.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;
  final ValueNotifier<bool> _hasChanges = ValueNotifier<bool>(false);
  bool _isLoadingEditMode = false;

  String _originalTitle = '';
  String _originalContent = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _titleController.addListener(_checkForChanges);
    _contentController.addListener(_checkForChanges);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final currentNote = noteProvider.notes.firstWhere(
        (n) => n.id == widget.note.id,
        orElse: () => widget.note,
      );
      _titleController.text = currentNote.title;
      _contentController.text = currentNote.content;
      _originalTitle = currentNote.title;
      _originalContent = currentNote.content;
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkForChanges);
    _contentController.removeListener(_checkForChanges);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    if (_isEditing) {
      final changed =
          (_titleController.text.trim() != _originalTitle.trim() ||
          _contentController.text.trim() != _originalContent.trim());
      if (_hasChanges.value != changed) {
        _hasChanges.value = changed;
      }
    }
  }

  Future<bool> _saveChangesLogic() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final t = Translations.of(context);
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.note_detail_screen.title_empty_error_snackbar),
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }

    noteProvider.updateNote(
      widget.note.id,
      _titleController.text.trim(),
      _contentController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.note_detail_screen.changes_saved_snackbar),
        duration: const Duration(seconds: 2),
      ),
    );

    return true;
  }

  void _discardChanges() {
    setState(() {
      _isEditing = false;
      _isLoadingEditMode = false;
      _titleController.text = _originalTitle;
      _contentController.text = _originalContent;
    });
    _hasChanges.value = false;
  }

  Future<bool> _showConfirmationDialog(String contentText) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            bool dialogIsSaving = false;
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 24.0,
                  ),
                  title: Text(t.note_detail_screen.dialog_title),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Text(contentText),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: dialogIsSaving
                          ? null
                          : () => Navigator.of(dialogContext).pop(false),
                      child: Text(t.note_detail_screen.dialog_cancel_button),
                    ),
                    FilledButton.tonal(
                      onPressed: dialogIsSaving
                          ? null
                          : () {
                              _discardChanges();
                              Navigator.of(dialogContext).pop(true);
                            },
                      child: Text(t.note_detail_screen.dialog_discard_button),
                    ),
                    ElevatedButton(
                      onPressed: dialogIsSaving
                          ? null
                          : () async {
                              setStateDialog(() => dialogIsSaving = true);
                              await Future.delayed(
                                const Duration(milliseconds: 550),
                              );
                              final saveSuccess = await _saveChangesLogic();
                              if (!dialogContext.mounted) return;
                              Navigator.of(dialogContext).pop(saveSuccess);
                              if (saveSuccess) {
                                setState(() {
                                  _isEditing = false;
                                  _isLoadingEditMode = false;
                                  _originalTitle = _titleController.text.trim();
                                  _originalContent = _contentController.text
                                      .trim();
                                });
                                _hasChanges.value = false;
                              }
                            },
                      child: dialogIsSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(t.note_detail_screen.dialog_ok_button),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
  }

  Future<bool> _showSaveConfirmationDialog() async {
    return _showConfirmationDialog(
      t.note_detail_screen.dialog_content_save_confirm,
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (_isEditing && _hasChanges.value) {
      return _showConfirmationDialog(
        t.note_detail_screen.dialog_content_exit_confirm,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final currentNote = noteProvider.notes.firstWhere(
      (n) => n.id == widget.note.id,
      orElse: () => widget.note,
    );

    if (!_isEditing) {
      if (_titleController.text != currentNote.title) {
        _titleController.text = currentNote.title;
      }
      if (_contentController.text != currentNote.content) {
        _contentController.text = currentNote.content;
      }
      _originalTitle = currentNote.title;
      _originalContent = currentNote.content;
    }

    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final router = GoRouter.of(context);
        final shouldPop = await _showExitConfirmationDialog();
        if (!mounted) return;
        if (shouldPop) router.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final router = GoRouter.of(context);
              final shouldPop = await _showExitConfirmationDialog();
              if (!mounted) return;
              if (shouldPop) router.pop();
            },
          ),
          title: _isEditing
              ? Text(t.note_detail_screen.edit_note_title)
              : const Text(''),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _hasChanges,
              builder: (context, hasChangesValue, child) {
                return IconButton(
                  icon: _isEditing
                      ? (hasChangesValue
                            ? const Icon(Icons.save)
                            : const Icon(Icons.edit_off))
                      : const Icon(Icons.edit),
                  tooltip: _isEditing
                      ? (hasChangesValue
                          ? t.note_detail_screen.save_btn
                          : t.note_detail_screen.cancel_edit_btn)
                      : t.note_detail_screen.edit_btn,
                  onPressed: () async {
                    if (_isEditing) {
                      if (hasChangesValue) {
                        await _showSaveConfirmationDialog();
                      } else {
                        _discardChanges();
                      }
                    } else {
                      setState(() => _isLoadingEditMode = true);
                      await Future.delayed(const Duration(milliseconds: 250));
                      setState(() {
                        _isLoadingEditMode = false;
                        _isEditing = true;
                        _originalTitle = _titleController.text;
                        _originalContent = _contentController.text;
                      });
                      _hasChanges.value = false;
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoadingEditMode
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isEditing
                          ? TextField(
                              controller: _titleController,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelText: t.note_detail_screen.title_label,
                                hintText: t.note_detail_screen.title_hint,
                                border: const OutlineInputBorder(),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              minLines: 1,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            )
                          : Text(
                              currentNote.title,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: null,
                            ),
                      const SizedBox(height: 8),
                      if (!_isEditing)
                        Text(
                          t.note_card.created_at.replaceAll(
                            '{date}',
                            DateFormat.yMMMd(
                              LocaleSettings.currentLocale.languageCode,
                            ).add_jm().format(currentNote.createdAt),
                          ),
                          style: textTheme.bodySmall,
                        ),
                      const Divider(height: 32, thickness: 1.0),
                      Text(
                        t.note_detail_screen.content_label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _isEditing
                            ? TextField(
                                controller: _contentController,
                                style: textTheme.bodyLarge?.copyWith(
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: t.note_detail_screen.content_hint,
                                ),
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                keyboardType: TextInputType.multiline,
                              )
                            : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: currentNote.content.trim().isEmpty
                                    ? Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          top: 100.0,
                                        ),
                                        child: Text(
                                          t
                                              .note_detail_screen
                                              .no_content_placeholder,
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          bottom: 40.0,
                                        ),
                                        child: Text(
                                          currentNote.content,
                                          style: textTheme.bodyLarge?.copyWith(
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
