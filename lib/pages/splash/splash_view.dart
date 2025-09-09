import 'package:drift_demo/pages/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  final controller = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Splash")),
    );
  }
}
