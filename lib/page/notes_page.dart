import 'package:flutter/material.dart';
import 'package:flutter_isarstorage/models/note.dart';
import 'package:flutter_isarstorage/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
              labelText: 'Note', hintText: 'Remember to...'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<NoteDatabase>().addNote(textController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green, // foreground
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.save), Text('Save')],
            ),
          )
        ],
      ),
    );
  }

  void readNotes() {
    context.watch<NoteDatabase>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    int selectedItem;
    final noteDatabase = context.watch<NoteDatabase>();

    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes With IsarStorage'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote();
        },
        child: const Icon(Icons.plus_one),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            final note = currentNotes[index];
            return Card(
              child: ListTile(
                title: Text(note.text.toString()),
                trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            value: note.id,
                            child: const Row(
                              children: [Icon(Icons.edit), Text('Edit')],
                            ),
                          ),
                          PopupMenuItem(
                            value: note.id,
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ]),
              ),
            );
          }),
    );
  }
}
