import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindr/constants/app_strings.dart';
import 'package:remindr/controllers/task_controller.dart';
import 'package:remindr/views/create_task_view.dart';
import 'package:remindr/widgets/task_card.dart';

// MediaQuery var for global usage
var device;

class TaskListView extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    device = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
      ),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppStrings.noTaskImage,
                ),
                SizedBox(height: device.height * 0.05),
                Text(
                  AppStrings.noTaskAdded,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20),
                child: TaskCard(task: taskController.tasks[index]),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const TaskCreationView());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
