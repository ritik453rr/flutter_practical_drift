import 'package:drift_demo/database/app_database.dart';
import 'package:drift_demo/database/database_queries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

/// Main screen of the application that displays a list of notes with CRUD operations
class HomeView extends GetView<HomeController> {
  /// Creates a new instance of the home view
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        return controller.notes.isEmpty
            ? const Center(child: Text("Empty List"))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  final note = controller.notes[index];
                  return _buildNoteCard(note);
                },
              );
      }),
    );
  }

  /// Builds a card widget for displaying a note in the list
  Widget _buildNoteCard(NotesEntityData note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {},
        trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              DatabaseQueries.deleteNote(note.id);
            }),
      ),
    );
  }
}

/// Shows a dialog to add a new note
void showAddNoteDialog(BuildContext context) {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              if (title.isEmpty || content.isEmpty) {
                Get.snackbar("Error", "Title and content cannot be empty");
                return;
              }

              final now = DateTime.now().toString();
              final uuid = DateTime.now().toString(); // or use uuid package

              await DatabaseQueries.addOrUpdateNote(
                title: title,
                content: content,
                id: uuid,
                createdAt: now,
                updatedAt: now,
              );

              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
