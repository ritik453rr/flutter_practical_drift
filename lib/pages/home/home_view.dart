import 'package:drift_demo/pages/home/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

/// Main screen of the application that displays a list of notes with CRUD operations
class HomeView extends StatelessWidget {
  HomeView({super.key});
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddNoteDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        return controller.notes.isEmpty
            ? const Center(child: Text("Empty Notes"))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  final note = controller.notes[index];
                  return noteCard(note);
                },
              );
      }),
    );
  }
}
