import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  // Mô phỏng việc tải dữ liệu
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('notes');
    if (notesString != null) {
      final List<dynamic> notesJson = jsonDecode(notesString);
      _notes = notesJson.map((json) => Note.fromMap(json)).toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> notesJson = _notes
        .map((note) => note.toMap())
        .toList();
    await prefs.setString('notes', jsonEncode(notesJson));
  }

  void addNote(String title, String content) {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    _notes.insert(0, newNote);
    _saveNotes();
    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotes();
    notifyListeners();
  }

  // ======================== PHƯƠNG THỨC MỚI: CẬP NHẬT GHI CHÚ ========================
  void updateNote(String id, String newTitle, String newContent) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      // Tạo một ghi chú mới với thông tin cập nhật, giữ nguyên createdAt và id
      _notes[index] = Note(
        id: id,
        title: newTitle,
        content: newContent,
        createdAt: _notes[index].createdAt, // Giữ nguyên thời gian tạo
      );
      _saveNotes();
      notifyListeners();
    }
  }
  // ======================== BACKUP & RESTORE ========================

  /// Thêm ghi chú từ backup (giữ nguyên id + createdAt gốc)
  void addNoteFromBackup(Note note) {
    _notes.insert(0, note);
    _saveNotes();
    notifyListeners();
  }

  /// Thay thế ghi chú hiện tại bằng ghi chú từ backup
  void replaceNote(String existingId, Note backupNote) {
    final index = _notes.indexWhere((n) => n.id == existingId);
    if (index != -1) {
      _notes[index] = Note(
        id: existingId,
        title: backupNote.title,
        content: backupNote.content,
        createdAt: backupNote.createdAt,
      );
      _saveNotes();
      notifyListeners();
    }
  }

  static bool _isSameSecond(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute &&
        a.second == b.second;
  }

  /// Kiểm tra có ghi chú cùng thời gian tạo
  bool hasNoteWithCreatedAt(DateTime createdAt) {
    return _notes.any((n) => _isSameSecond(n.createdAt, createdAt));
  }

  /// Tìm ghi chú theo thời gian tạo
  Note? findNoteByCreatedAt(DateTime createdAt) {
    for (final note in _notes) {
      if (_isSameSecond(note.createdAt, createdAt)) {
        return note;
      }
    }
    return null;
  }

  /// Tính số thứ tự đổi tên tiếp theo (ví dụ: "Hello (1)", "Hello (2)")
  int getNextRenameSuffix(String title) {
    int maxSuffix = 0;
    final pattern = RegExp(r'^' + RegExp.escape(title) + r' \((\d+)\)$');
    for (final note in _notes) {
      if (note.title == title) {
        maxSuffix = maxSuffix < 1 ? 1 : maxSuffix;
      }
      final match = pattern.firstMatch(note.title);
      if (match != null) {
        final num = int.parse(match.group(1)!);
        if (num >= maxSuffix) maxSuffix = num + 1;
      }
    }
    return maxSuffix < 1 ? 1 : maxSuffix;
  }
}
