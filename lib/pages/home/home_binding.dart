import 'package:get/get.dart';
import 'home_controller.dart';

/// Binds the HomeController to the HomeView using GetX dependency injection
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
