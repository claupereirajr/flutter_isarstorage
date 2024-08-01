import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:flutter_isarstorage/models/note.dart";

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Note> currentNotes = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  Future<void> addNote(String inputText) async {
    final newNote = Note()..text = inputText;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNote(int id, String inputText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = inputText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
      await fetchNotes();
    });
  }
}
