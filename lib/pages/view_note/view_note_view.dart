import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/model/note_model.dart';
import '../home/home_controller.dart';

/// Screen for viewing, creating and editing notes
class ViewNoteView extends StatelessWidget {
  /// The note being edited, or null if creating a new note
  final Note? note;

  /// Debouncer for auto-saving changes
  final _debouncer = Debouncer(milliseconds: 1000);

  /// Controller for managing note operations
  final HomeController controller = Get.find<HomeController>();

  /// Controller for the note title input field
  final TextEditingController _titleController = TextEditingController();

  /// Controller for the note content input field
  final TextEditingController _contentController = TextEditingController();

  /// Whether this is a new note being created
  final RxBool _isNewNote = true.obs;

  /// Whether the note is currently being saved
  final RxBool _isSaving = false.obs;

  /// Error message to display if something goes wrong
  final RxString _errorMessage = ''.obs;

  /// Focus node for the title input field
  final FocusNode _titleFocus = FocusNode();

  /// Focus node for the content input field
  final FocusNode _contentFocus = FocusNode();

  /// Creates a new instance of the view note screen
  ViewNoteView({super.key, this.note}) {
    if (note != null) {
      _titleController.text = note!.title;
      _contentController.text = note!.content;
      _isNewNote.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _clearFocus(context),
      child: WillPopScope(
        onWillPop: () async {
          if (_isNewNote.value) {
            final title = _titleController.text.trim();
            final content = _contentController.text.trim();
            if (title.isNotEmpty || content.isNotEmpty) {
              await _saveNote();
            }
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Obx(() {
              if (_isSaving.value) {
                return const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Saving...'),
                  ],
                );
              }
              return Text(
                  _isNewNote.value ? 'New Note' : _titleController.text);
            }),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Obx(() {
                if (_errorMessage.value.isNotEmpty) {
                  return Container(
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _errorMessage.value = '',
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _titleController,
                                focusNode: _titleFocus,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: _handleTextChange,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    _contentFocus.requestFocus(),
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _contentController,
                                focusNode: _contentFocus,
                                style: const TextStyle(fontSize: 16),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                decoration: const InputDecoration(
                                  hintText: 'Start typing your note...',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: _handleTextChange,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!_isNewNote.value) ...[
                        const SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Note Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildDetailRow('Created', note!.createdAt),
                                const SizedBox(height: 4),
                                _buildDetailRow(
                                    'Last Modified', note!.updatedAt),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Clears focus from all text fields
  void _clearFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Handles text changes in input fields
  void _handleTextChange(String value) {
    if (!_isNewNote.value) {
      _debouncer.run(_saveNote);
    }
  }

  /// Saves the current note to the database
  Future<void> _saveNote() async {
    try {
      _isSaving.value = true;
      _errorMessage.value = '';

      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      if (_isNewNote.value) {
        await controller.addNote(title, content);
      } else {
        await controller.updateNote(note!, title, content);
      }
    } catch (e) {
      _errorMessage.value = 'Failed to save note: $e';
    } finally {
      _isSaving.value = false;
    }
  }

  /// Builds a row displaying a note detail with a label
  Widget _buildDetailRow(String label, DateTime date) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          _formatDate(date),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Formats a date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Utility class for debouncing repeated actions
class Debouncer {
  /// The delay duration in milliseconds
  final int milliseconds;

  /// The timer instance for debouncing
  Timer? _timer;

  /// Creates a new debouncer instance
  Debouncer({required this.milliseconds});

  /// Runs the provided action after the debounce delay
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
