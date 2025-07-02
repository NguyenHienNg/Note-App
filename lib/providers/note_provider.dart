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

    // Mô phỏng độ trễ mạng
    await Future.delayed(const Duration(seconds: 1));

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
    final List<Map<String, dynamic>> notesJson = _notes.map((note) => note.toMap()).toList();
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
  // ====================================================================================
}