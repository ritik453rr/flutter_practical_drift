import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routing/app_pages.dart';
import 'routing/app_routes.dart';

/// Entry point of the application that sets up GetX navigation and theme
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}

