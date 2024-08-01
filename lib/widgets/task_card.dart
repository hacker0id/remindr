import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindr/controllers/task_controller.dart';
import 'package:remindr/models/task_model.dart';
import 'package:remindr/views/task_edit_view.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final TaskController taskController = Get.find();

  TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Get.to(() => TaskEditView(task: task));
      },
      child: Card(
        color: task.isCompleted ? Colors.redAccent : Colors.blueAccent,
        child: ListTile(
          leading: Checkbox(
            //checkColor: Colors.white,
            activeColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 2),
            value: task.isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                taskController.markTaskAsDone(task.id, value);
              }
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade200,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < task.priority ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          trailing: task.isCompleted
              ? IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    taskController.deleteTask(task.id);
                  },
                )
              : null,
        ),
      ),
    );
  }
}
