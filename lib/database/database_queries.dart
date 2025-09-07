import 'package:drift_demo/database/app_database.dart';
import 'package:drift_demo/global.dart';
import 'package:drift/drift.dart';

/// Provides high-level methods to interact with the notes database.
class DatabaseQueries {
  /// Watches all notes in real-time as a stream.
  static Stream<List<NotesEntityData>> watchAllNotes() {
    return Global.database.select(Global.database.notesEntity).watch();
  }

   /// Adds or updates a note in the database if the ID already exists.
  static Future<int> addOrUpdateNote({
    required String title,
    required String content,
    required String id,
    required String createdAt,
    required String updatedAt,
  }) {
    return Global.database.into(Global.database.notesEntity).insertOnConflictUpdate(
      NotesEntityCompanion(
        id: Value(id),
        title: Value(title),
        content: Value(content),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }
  /// Deletes a note from the database by its ID.
  static Future<void> deleteNote(String id) {
    return (Global.database.delete(Global.database.notesEntity)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  /// Updates the given note in the database.
  static Future<void> updateNote(NotesEntityData note) async {
    await Global.database.update(Global.database.notesEntity).replace(note);
  }
}
