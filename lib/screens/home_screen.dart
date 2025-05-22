import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/db_service.dart';
import 'add_note_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> _notes = [];

  final List<Color> cardColors = [
    Colors.redAccent,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  Future<void> _loadNotes() async {
    final notes = await DBService.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _showNoteOptions(BuildContext context, NoteModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(note.isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined),
                title: Text(note.isPinned == 1 ? 'Unpin' : 'Pin'),
                onTap: () {
                  Navigator.pop(ctx);
                  _togglePin(note);
                },
              ),
              // Removed the alarm ListTile
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _editNote(note);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteNote(note);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _togglePin(NoteModel note) async {
    final newIsPinned = note.isPinned == 1 ? 0 : 1;
    final updatedNote = note.copyWith(isPinned: newIsPinned);
    await DBService.updateNote(updatedNote);
    _loadNotes();
  }

  Future<void> _editNote(NoteModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNoteScreen(note: note),
      ),
    );
    _loadNotes();
  }

  void _deleteNote(NoteModel note) async {
    await DBService.deleteNote(note.id!);
    _loadNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted "${note.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: _notes.isEmpty
            ? const Center(
          child: Text(
            'No notes added yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : GridView.builder(
          itemCount: _notes.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (ctx, index) {
            final note = _notes[index];
            final color = cardColors[index % cardColors.length].withOpacity(0.9);
            final timestamp = note.timestamp != null
                ? DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(note.timestamp!))
                : '';

            return GestureDetector(
              onTap: () => _showNoteOptions(context, note),
              child: Card(
                color: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          note.content,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timestamp,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Icon(
                            note.isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined,
                            color: note.isPinned == 1 ? Colors.red : Colors.white70,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
