import 'package:get/get.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/view_note/view_note_view.dart';
import 'app_routes.dart';

/// Contains all page definitions with their bindings and routes for GetX navigation
abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.viewNote,
      page: () => ViewNoteView(note: Get.arguments),
    ),
  ];
}
