import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../i18n/strings.g.dart';

void showAddNoteSheet(BuildContext context) {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final t = Translations.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool isFormSubmitted = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                Text(t.add_note_sheet.add_note_title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: t.add_note_sheet.title_label,
                    hintText: t.add_note_sheet.title_hint,
                    border: OutlineInputBorder(),
                    errorText: isFormSubmitted && titleController.text.trim().isEmpty
                        ? t.add_note_sheet.title_empty_error
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: t.add_note_sheet.content_label,
                    hintText: t.add_note_sheet.content_hint, // THAY ĐỔI: Thêm hintText
                    border: OutlineInputBorder(),
                    isDense: true,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      isFormSubmitted = true;
                    });

                    if (titleController.text.trim().isNotEmpty) {
                      Provider.of<NoteProvider>(context, listen: false).addNote(
                        titleController.text.trim(),
                        contentController.text.trim(),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(t.add_note_sheet.save_note_button),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}