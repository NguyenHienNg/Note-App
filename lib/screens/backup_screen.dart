import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../i18n/strings.g.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final Set<String> _selectedIds = {};

  bool get _allSelected {
    final notes = Provider.of<NoteProvider>(context, listen: false).notes;
    return notes.isNotEmpty && _selectedIds.length == notes.length;
  }

  void _toggleSelectAll() {
    final notes = Provider.of<NoteProvider>(context, listen: false).notes;
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(notes.map((n) => n.id));
      }
    });
  }

  Future<void> _exportBackup() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final selectedNotes = noteProvider.notes
        .where((n) => _selectedIds.contains(n.id))
        .toList();

    if (selectedNotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.settings_screen.backup_no_selection)),
      );
      return;
    }

    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    try {
      if (selectedNotes.length == 1) {
        // Xuất file .json đơn
        final jsonStr = const JsonEncoder.withIndent(
          '  ',
        ).convert(selectedNotes[0].toMap());
        final bytes = Uint8List.fromList(utf8.encode(jsonStr));

        final result = await FilePicker.saveFile(
          dialogTitle: t.settings_screen.backup_export_tooltip,
          fileName: 'backup_$dateStr.json',
          bytes: bytes,
        );

        if (result != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.settings_screen.backup_success)),
          );
        }
      } else {
        // Xuất file .zip
        final archive = Archive();
        for (final note in selectedNotes) {
          final jsonStr = const JsonEncoder.withIndent(
            '  ',
          ).convert(note.toMap());
          final bytes = utf8.encode(jsonStr);
          // Tên file: title sanitized + id suffix để tránh trùng
          final safeTitle = note.title
              .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
              .replaceAll(RegExp(r'\s+'), '_');
          final fileName = '${safeTitle}_${note.id.hashCode.abs()}.json';
          archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
        }
        final zipBytes = ZipEncoder().encode(archive);

        final result = await FilePicker.saveFile(
          dialogTitle: t.settings_screen.backup_export_tooltip,
          fileName: 'backup_$dateStr.zip',
          bytes: Uint8List.fromList(zipBytes),
        );

        if (result != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.settings_screen.backup_success)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_screen.backup_select_notes),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: t.settings_screen.backup_export_tooltip,
            onPressed: _selectedIds.isEmpty ? null : _exportBackup,
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, _) {
          if (noteProvider.notes.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/undraw_relaxed-reading_wfkr.svg',
                      height: 180,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.settings_screen.backup_no_notes,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Nút chọn tất cả / bỏ chọn tất cả
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '${_selectedIds.length}/${noteProvider.notes.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _toggleSelectAll,
                      child: Text(
                        _allSelected
                            ? t.settings_screen.backup_deselect_all
                            : t.settings_screen.backup_select_all,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Danh sách ghi chú
              Expanded(
                child: ListView.builder(
                  itemCount: noteProvider.notes.length,
                  itemBuilder: (context, index) {
                    final note = noteProvider.notes[index];
                    final isSelected = _selectedIds.contains(note.id);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedIds.add(note.id);
                          } else {
                            _selectedIds.remove(note.id);
                          }
                        });
                      },
                      title: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd(
                          LocaleSettings.currentLocale.languageCode,
                        ).add_jm().format(note.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      secondary: const Icon(Icons.note_outlined),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
