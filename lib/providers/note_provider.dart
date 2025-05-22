import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/db_service.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await DBService.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    await DBService.insertNote(note);
    await loadNotes();
  }
}
