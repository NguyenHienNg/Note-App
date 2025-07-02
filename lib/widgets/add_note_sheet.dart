import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

void showAddNoteSheet(BuildContext context) {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

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
                Text('Tạo ghi chú', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    hintText: 'Ví dụ: Lên kế hoạch cuối tuần', // THAY ĐỔI: Thêm hintText
                    border: OutlineInputBorder(),
                    errorText: isFormSubmitted && titleController.text.trim().isEmpty
                        ? 'Tiêu đề không được để trống.'
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung',
                    hintText: 'Ví dụ: Đi siêu thị, tập thể dục, đọc sách...', // THAY ĐỔI: Thêm hintText
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
                  child: const Text('Lưu ghi chú'),
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