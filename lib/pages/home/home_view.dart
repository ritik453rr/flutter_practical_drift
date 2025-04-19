import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_note/view_note_view.dart';
import 'home_controller.dart';
import 'model/note_model.dart';

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadNotes,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.notes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_add, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No notes yet\nTap + to add a note',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotes,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return _buildNoteCard(note);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ViewNoteView()),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds a card widget for displaying a note in the list
  Widget _buildNoteCard(Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          note.title.isEmpty ? 'Untitled' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Get.to(() => ViewNoteView(note: note)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _showDeleteDialog(note),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a note
  void _showDeleteDialog(Note note) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: Text(
          'Are you sure you want to delete "${note.title.isEmpty ? 'Untitled' : note.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteNote(note.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
