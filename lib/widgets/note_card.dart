// lib/widgets/note_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../screens/note_detail_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    // ======================== BẮT ĐẦU THAY ĐỔI ========================
    return Card(
      // Thêm thuộc tính này để đảm bảo các widget con bị cắt theo góc bo
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell( // Bọc ListTile trong InkWell để quản lý hiệu ứng nhấn
        onTap: () {
          // Điều hướng đến màn hình chi tiết khi nhấn vào
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(note: note),
            ),
          );
        },
        child: ListTile(
          // Bỏ onTap ra khỏi ListTile vì InkWell đã xử lý
          title: Text(note.title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(
            'Tạo lúc: ${DateFormat.yMd().add_jm().format(note.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // ... (Phần code xóa không thay đổi)
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xác nhận xóa'),
                  content: const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Hủy'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    FilledButton.tonal(
                      child: const Text('Xóa'),
                      onPressed: () {
                        Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id);
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã xóa ghi chú!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    // ======================== KẾT THÚC THAY ĐỔI ========================
  }
}