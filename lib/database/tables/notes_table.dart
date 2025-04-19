import 'package:drift/drift.dart';

/// Defines the structure of the Notes table in the database
class Notes extends Table {
  /// Unique identifier for each note
  IntColumn get id => integer().autoIncrement()();

  /// Title of the note, optional
  TextColumn get title => text().nullable()();

  /// Content/body of the note, optional
  TextColumn get content => text().nullable()();

  /// Timestamp when the note was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the note was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'CONSTRAINT valid_title CHECK (title IS NULL OR length(title) <= 255)',
      ];
}
