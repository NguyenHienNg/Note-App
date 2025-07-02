import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

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
  bool _hasChanges = false;
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
      final changed = (_titleController.text.trim() != _originalTitle.trim() ||
          _contentController.text.trim() != _originalContent.trim());

      if (_hasChanges != changed) {
        setState(() {
          _hasChanges = changed;
        });
      }
    }
  }

  Future<bool> _saveChangesLogic() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Tiêu đề không được để trống!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return false; // Lỗi validation
    }

    noteProvider.updateNote(
      widget.note.id,
      _titleController.text.trim(),
      _contentController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã lưu thay đổi!',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        duration: const Duration(seconds: 2),
      ),
    );

    return true; // Lưu thành công
  }

  void _discardChanges() {
    setState(() {
      _isEditing = false;
      _hasChanges = false;
      _isLoadingEditMode = false;
      _titleController.text = _originalTitle;
      _contentController.text = _originalContent;
    });
  }

  Future<bool> _showSaveConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool dialogIsSaving = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nhắc nhở'),
              content: const Text('Bạn chắc chắn muốn lưu thay đổi này không?'),
              actions: <Widget>[
                TextButton(
                  onPressed: dialogIsSaving
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop(false);
                        },
                  child: const Text('Hủy'),
                ),
                FilledButton.tonal(
                  onPressed: dialogIsSaving
                      ? null
                      : () {
                          _discardChanges();
                          Navigator.of(dialogContext).pop(true);
                        },
                  child: const Text('Không lưu'),
                ),
                ElevatedButton(
                  onPressed: dialogIsSaving
                      ? null
                      : () async {
                          setStateDialog(() {
                            dialogIsSaving = true;
                          });
                          await Future.delayed(const Duration(milliseconds: 550));

                          final saveSuccess = await _saveChangesLogic();

                          Navigator.of(dialogContext).pop(saveSuccess);

                          if (saveSuccess) {
                            setState(() {
                              _isEditing = false;
                              _hasChanges = false;
                              _isLoadingEditMode = false;
                              _originalTitle = _titleController.text.trim();
                              _originalContent = _contentController.text.trim();
                            });
                          }
                        },
                  child: dialogIsSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ) ?? false;
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (_isEditing && _hasChanges) {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          bool dialogIsSaving = false;
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: const Text('Nhắc nhở'),
                content: const Text('Bạn có chắc muốn lưu thay đổi này không?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: dialogIsSaving
                        ? null
                        : () {
                            Navigator.of(dialogContext).pop(false);
                          },
                    child: const Text('Hủy'),
                  ),
                  FilledButton.tonal(
                    onPressed: dialogIsSaving
                        ? null
                        : () {
                            _discardChanges();
                            Navigator.of(dialogContext).pop(true);
                          },
                    child: const Text('Không lưu'),
                  ),
                  ElevatedButton(
                    onPressed: dialogIsSaving
                        ? null
                        : () async {
                            setStateDialog(() {
                              dialogIsSaving = true;
                            });
                            await Future.delayed(const Duration(milliseconds: 550));

                            final saveSuccess = await _saveChangesLogic();

                            Navigator.of(dialogContext).pop(saveSuccess);

                            if (saveSuccess) {
                              setState(() {
                                _isEditing = false;
                                _hasChanges = false;
                                _isLoadingEditMode = false;
                                _originalTitle = _titleController.text.trim();
                                _originalContent = _contentController.text.trim();
                              });
                            }
                          },
                    child: dialogIsSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      ) ?? false;
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

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _showExitConfirmationDialog();
              if (shouldPop) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: _isEditing ? const Text('Chỉnh sửa ghi chú') : const Text(''),
          actions: [
            IconButton(
              icon: _isEditing
                  ? (_hasChanges ? const Icon(Icons.check) : const Icon(Icons.close))
                  : const Icon(Icons.edit),
              onPressed: () async {
                if (_isEditing) {
                  if (_hasChanges) {
                    await _showSaveConfirmationDialog();
                  } else {
                    _discardChanges();
                  }
                } else {
                  setState(() {
                    _isLoadingEditMode = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 250));
                  setState(() {
                    _isLoadingEditMode = false;
                    _isEditing = true;
                    _hasChanges = false;
                    _originalTitle = _titleController.text;
                    _originalContent = _contentController.text;
                  });
                }
              },
            ),
          ],
        ),
        body: _isLoadingEditMode
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                            decoration: const InputDecoration(
                              labelText: 'Tiêu đề',
                              hintText: 'Nhập tiêu đề ghi chú...',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        'Tạo lúc: ${DateFormat.yMMMMEEEEd().add_jm().format(currentNote.createdAt)}',
                        style: textTheme.bodySmall,
                      ),
                    const Divider(height: 32, thickness: 1.0),
                    Text(
                      'Nội dung:',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                            controller: _contentController,
                            style: textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nhập nội dung ghi chú...',
                            ),
                            maxLines: null,
                            minLines: 8,
                            keyboardType: TextInputType.multiline,
                          )
                        : (currentNote.content.trim().isEmpty
                            ? Column( // Bọc trong Column để thêm SizedBox
                                children: [
                                  const SizedBox(height: 200.0), // THAY ĐỔI: Tăng khoảng trống lên 100px
                                  Center(
                                    child: Text(
                                      'Chẳng có gì ¯\\_(ツ)_/¯',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                currentNote.content,
                                style: textTheme.bodyLarge?.copyWith(
                                  height: 1.5,
                                ),
                              )),
                  ],
                ),
              ),
      ),
    );
  }
}