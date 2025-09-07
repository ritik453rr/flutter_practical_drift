import 'package:drift/drift.dart';

/// Defines the structure of the Notes table in the database
class NotesEntity extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get content => text()();

  TextColumn get createdAt => text()();

  TextColumn get updatedAt => text()();

  /// Declares 'id' as the primary key for the table
  @override
  Set<Column> get primaryKey => {id};
}
