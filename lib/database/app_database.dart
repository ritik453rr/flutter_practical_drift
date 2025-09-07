import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/notes_entity.dart';

part 'app_database.g.dart';

/// Main database class that handles all database operations for the notes app
@DriftDatabase(tables: [NotesEntity])
class AppDatabase extends _$AppDatabase {
  /// Creates a new instance of the database
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

/// Creates a lazy database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
