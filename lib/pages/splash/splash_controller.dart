import 'package:drift_demo/database/database_queries.dart';
import 'package:drift_demo/pages/home/home_controller.dart';
import 'package:drift_demo/routing/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navi();
  }

  void navi() {
    Get.find<HomeController>()
        .notes
        .bindStream(DatabaseQueries.watchAllNotes());

    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed(AppRoutes.home);
    });
  }
}
