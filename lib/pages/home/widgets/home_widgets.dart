import 'package:drift_demo/database/app_database.dart';
import 'package:drift_demo/database/database_queries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Builds a card widget for displaying a note in the list
Widget noteCard(NotesEntityData note) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      onTap: () {
        showAddNoteDialog(editMode: true, note: note);
      },
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
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            DatabaseQueries.deleteNote(note.id);
          }),
    ),
  );
}

/// Shows a dialog to add a new note
void showAddNoteDialog({bool editMode = false, NotesEntityData? note}) {
  final titleController = TextEditingController(text: note?.title ?? "");
  final contentController = TextEditingController(text: note?.content ?? "");

  showDialog(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Note"),
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
            onPressed: () => Get.back(),
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
              await DatabaseQueries.addOrUpdateNote(
                  note: NotesEntityData(
                id: editMode ? note!.id : DateTime.now().toString(),
                title: title,
                content: content,
                createdAt:
                    editMode ? note!.createdAt : DateTime.now().toString(),
                updatedAt: DateTime.now().toString(),
              ));

              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
