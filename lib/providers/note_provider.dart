import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

// --- Hàm tiện ích chạy ngoài luồng UI (Isolate) qua compute ---
List<Note> _parseNotesBackground(String jsonString) {
  final List<dynamic> notesJson = jsonDecode(jsonString);
  return notesJson.map((json) => Note.fromMap(json as Map<String, dynamic>)).toList();
}

String _encodeNotesBackground(List<Map<String, dynamic>> notesMap) {
  return jsonEncode(notesMap);
}

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('notes');
    if (notesString != null && notesString.isNotEmpty) {
      _notes = await compute(_parseNotesBackground, notesString);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> notesJson =
        _notes.map((note) => note.toMap()).toList();
    final String encoded = await compute(_encodeNotesBackground, notesJson);
    await prefs.setString('notes', encoded);
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

  void updateNote(String id, String newTitle, String newContent) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: id,
        title: newTitle,
        content: newContent,
        createdAt: _notes[index].createdAt,
      );
      _saveNotes();
      notifyListeners();
    }
  }

  void addNoteFromBackup(Note note) {
    _notes.insert(0, note);
    _saveNotes();
    notifyListeners();
  }

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

  bool hasNoteWithCreatedAt(DateTime createdAt) {
    return _notes.any((n) => _isSameSecond(n.createdAt, createdAt));
  }

  Note? findNoteByCreatedAt(DateTime createdAt) {
    for (final note in _notes) {
      if (_isSameSecond(note.createdAt, createdAt)) {
        return note;
      }
    }
    return null;
  }

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
