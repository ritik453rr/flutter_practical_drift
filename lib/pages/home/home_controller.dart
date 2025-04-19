import 'package:get/get.dart';
import 'package:drift/drift.dart' as d;
import '../../database/app_database.dart' as drift;
import 'model/note_model.dart';

/// Controller that manages the state and business logic for the notes list screen
class HomeController extends GetxController {
  /// Database instance for data persistence
  final drift.AppDatabase database = drift.AppDatabase();

  /// Observable list of notes to display
  final RxList<Note> notes = <Note>[].obs;

  /// Loading state indicator
  final RxBool isLoading = false.obs;

  /// Error message to display if something goes wrong
  final RxString errorMessage = ''.obs;

  final isEditing = false.obs;
  final editingNote = Rxn<Note>();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  @override
  void onClose() {
    database.close();
    super.onClose();
  }

  /// Loads all notes from the database
  Future<void> loadNotes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final dbNotes = await database.getAllNotes();
      notes.value = dbNotes
          .map((dbNote) => Note(
                id: dbNote.id,
                title: dbNote.title ?? '',
                content: dbNote.content ?? '',
                createdAt: dbNote.createdAt,
                updatedAt: dbNote.updatedAt,
              ))
          .toList();
    } catch (e) {
      errorMessage.value = 'Failed to load notes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds a new note to the database
  Future<void> addNote(String title, String content) async {
    try {
      errorMessage.value = '';
      final note = drift.NotesCompanion.insert(
        title: d.Value(title.trim()),
        content: d.Value(content.trim()),
        createdAt: d.Value(DateTime.now()),
        updatedAt: d.Value(DateTime.now()),
      );

      await database.insertNote(note);
      await loadNotes();
    } catch (e) {
      errorMessage.value = 'Failed to add note: $e';
      rethrow;
    }
  }

  /// Updates an existing note in the database
  Future<void> updateNote(Note note, String title, String content) async {
    try {
      errorMessage.value = '';
      final updatedNote = drift.NotesCompanion(
        id: d.Value(note.id),
        title: d.Value(title.trim()),
        content: d.Value(content.trim()),
        updatedAt: d.Value(DateTime.now()),
      );

      await database.updateNote(updatedNote);
      await loadNotes();
    } catch (e) {
      errorMessage.value = 'Failed to update note: $e';
      rethrow;
    }
  }

  /// Deletes a note from the database
  Future<void> deleteNote(int id) async {
    try {
      errorMessage.value = '';
      await database.deleteNote(id);
      await loadNotes();
    } catch (e) {
      errorMessage.value = 'Failed to delete note: $e';
      rethrow;
    }
  }

  /// Deletes multiple notes at once
  Future<void> deleteMultipleNotes(List<int> ids) async {
    try {
      errorMessage.value = '';
      await database.deleteMultipleNotes(ids);
      await loadNotes();
    } catch (e) {
      errorMessage.value = 'Failed to delete notes: $e';
      rethrow;
    }
  }

  /// Removes notes older than the specified number of days
  Future<void> cleanupOldNotes(int daysOld) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      await database.deleteOldNotes(cutoffDate);
      await loadNotes();
    } catch (e) {
      errorMessage.value = 'Failed to cleanup old notes: $e';
      rethrow;
    }
  }

  void startEditing(Note note) {
    editingNote.value = note;
    isEditing.value = true;
  }

  void cancelEditing() {
    editingNote.value = null;
    isEditing.value = false;
  }
}
