/// Represents a note in the application with its properties and metadata
class Note {
  /// Unique identifier for the note
  final int id;

  /// Title of the note
  String title;

  /// Content/body of the note
  String content;

  /// When the note was created
  final DateTime createdAt;

  /// When the note was last modified
  DateTime updatedAt;

  /// Creates a new note instance
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
