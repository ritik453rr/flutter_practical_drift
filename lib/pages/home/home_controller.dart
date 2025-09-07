import 'package:drift_demo/database/app_database.dart';
import 'package:drift_demo/database/database_queries.dart';
import 'package:get/get.dart';

/// Controller that manages the state and business logic for the notes list screen
class HomeController extends GetxController {
  /// Lists
  var notes = <NotesEntityData>[].obs;

  @override
  void onInit() {
    super.onInit();
     notes.bindStream(DatabaseQueries.watchAllNotes());
  }
}
