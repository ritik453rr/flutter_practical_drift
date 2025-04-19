import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/notes_table.dart';

part 'app_database.g.dart';

/// Main database class that handles all database operations for the notes app
@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  /// Creates a new instance of the database
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Retrieves all notes ordered by last update time
  Future<List<DbNote>> getAllNotes() => (select(notes)
        ..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
        ]))
      .get();

  /// Retrieves a single note by its ID
  Future<DbNote> getNoteById(int id) =>
      (select(notes)..where((note) => note.id.equals(id))).getSingle();

  /// Inserts a new note into the database
  Future<int> insertNote(NotesCompanion note) => into(notes).insert(note);

  /// Updates an existing note in the database
  Future<bool> updateNote(NotesCompanion note) => update(notes).replace(note);

  /// Deletes a note from the database by its ID
  Future<int> deleteNote(int id) =>
      (delete(notes)..where((note) => note.id.equals(id))).go();

  /// Deletes multiple notes at once by their IDs
  Future<void> deleteMultipleNotes(List<int> ids) async {
    await (delete(notes)..where((note) => note.id.isIn(ids))).go();
  }

  /// Deletes notes older than the specified date
  Future<void> deleteOldNotes(DateTime before) async {
    await (delete(notes)
          ..where((note) => note.updatedAt.isSmallerThanValue(before)))
        .go();
  }
}

/// Creates a lazy database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notes.db'));
    return NativeDatabase.createInBackground(file, logStatements: false,
        setup: (db) {
      db.execute('PRAGMA journal_mode=WAL');
      db.execute('PRAGMA synchronous=NORMAL');
    });
  });
}
