import 'package:drift_demo/pages/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  final controller = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextAnimator(
        "Splash View",
        characterDelay: const Duration(milliseconds: 100),
        incomingEffect: WidgetTransitionEffects(
            scale: 1, duration: const Duration(milliseconds: 2200)),
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      )),
    );
  }
}
