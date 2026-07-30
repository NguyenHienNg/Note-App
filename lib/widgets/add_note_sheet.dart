import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../i18n/strings.g.dart';

void showAddNoteSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _AddNoteSheetContent(),
  );
}

class _AddNoteSheetContent extends StatefulWidget {
  const _AddNoteSheetContent();

  @override
  State<_AddNoteSheetContent> createState() => _AddNoteSheetContentState();
}

class _AddNoteSheetContentState extends State<_AddNoteSheetContent> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isFormSubmitted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSave() {
    setState(() {
      _isFormSubmitted = true;
    });

    if (_titleController.text.trim().isNotEmpty) {
      Provider.of<NoteProvider>(context, listen: false).addNote(
        _titleController.text.trim(),
        _contentController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.add_note_sheet.add_note_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: t.add_note_sheet.title_label,
              hintText: t.add_note_sheet.title_hint,
              border: const OutlineInputBorder(),
              errorText:
                  _isFormSubmitted && _titleController.text.trim().isEmpty
                      ? t.add_note_sheet.title_empty_error
                      : null,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: t.add_note_sheet.content_label,
              hintText: t.add_note_sheet.content_hint,
              border: const OutlineInputBorder(),
              isDense: true,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _onSave,
            child: Text(t.add_note_sheet.save_note_button),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}