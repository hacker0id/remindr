import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:remindr/models/task_model.dart';
import 'package:remindr/services/notification_service.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  late Box<TaskModel> tasksBox;

  @override
  void onInit() {
    super.onInit();
    tasksBox = Hive.box<TaskModel>('tasksBox');
    loadTasks();
  }

  void loadTasks() {
    tasks.addAll(tasksBox.values);
  }

  void addTask(TaskModel task) {
    tasks.add(task);
    tasksBox.add(task);

    // NNotif schedule
    NotificationService.showNotification(
      id: task.key as int,
      title: 'Task Due Soon',
      body: '${task.title} is due on ${task.dueDate}',
      scheduledTime: task.dueDate,
    );

    // Disp Snackbar Task Added
    Get.snackbar(
      'Task Added',
      'Task "${task.title}" has been added.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void markTaskAsDone(String id, bool done) {
    var task = tasks.firstWhere((task) => task.id == id);
    task.isCompleted = done;
    tasks[tasks.indexOf(task)] = task;
    task.save();

    // Show Snackbar Marked Done
    Get.snackbar(
      'Task Updated',
      'Task "${task.title}" marked as ${done ? "done" : "not done"}.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void updateTask(TaskModel updatedTask) {
    int index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
  }

  void deleteTask(String id) {
    var task = tasks.firstWhere((task) => task.id == id);
    tasks.remove(task);
    task.delete();

    // Show Snackbar Task Deleted
    Get.snackbar(
      'Task Deleted',
      'Task "${task.title}" has been deleted.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
}
