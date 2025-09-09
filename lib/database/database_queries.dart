import 'package:drift_demo/database/app_database.dart';
import 'package:drift_demo/global.dart';
import 'package:drift/drift.dart';

/// Provides high-level methods to interact with the notes database.
class DatabaseQueries {
  /// Watches all notes in real-time as a stream.
  static Stream<List<NotesEntityData>> watchAllNotes() {
    return (Global.database.select(Global.database.notesEntity)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  /// Adds or updates a note in the database if the ID already exists.
  static Future<void> addOrUpdateNote({
    required NotesEntityData note,
  }) async {
    await Global.database
        .into(Global.database.notesEntity)
        .insertOnConflictUpdate(
          NotesEntityCompanion(
            id: Value(note.id),
            title: Value(note.title),
            content: Value(note.content),
            createdAt: Value(note.createdAt),
            updatedAt: Value(note.updatedAt),
          ),
        )
        .catchError((e) {
      print('Error:$e');
    });
  }

  /// Deletes a note from the database by its ID.
  static Future<void> deleteNote(String id) async {
    await (Global.database.delete(Global.database.notesEntity)
          ..where((tbl) => tbl.id.equals(id)))
        .go()
        .catchError((e) {
      print('Error deleting note with id $id: $e');
    });
  }
}
