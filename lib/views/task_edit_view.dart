import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindr/constants/app_strings.dart';
import 'package:remindr/constants/font_sizes.dart';
import 'package:remindr/constants/text_field_decoration.dart';
import 'package:remindr/controllers/task_controller.dart';
import 'package:remindr/models/task_model.dart';
import 'package:remindr/views/task_list_view.dart';

class TaskEditView extends StatefulWidget {
  final TaskModel task;

  const TaskEditView({required this.task, Key? key}) : super(key: key);

  @override
  _TaskEditViewState createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  final TaskController taskController = Get.find();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  double priority = 1;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController = TextEditingController(
        text: widget.task.dueDate.toIso8601String().split('T').first);
    priority = widget.task.priority.toDouble();
  }

  void _validateAndUpdateTask() {
    final title = titleController.text.trim();
    final dueDateText = dueDateController.text;

    if (title.isEmpty) {
      Get.snackbar(
        AppStrings.validationErr,
        AppStrings.emptyTitleMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (dueDateText.isEmpty) {
      Get.snackbar(
        AppStrings.validationErr,
        AppStrings.emptyDueDateMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final dueDate = DateTime.tryParse(dueDateText);
    if (dueDate == null) {
      Get.snackbar(
        AppStrings.validationErr,
        AppStrings.invalidDueDate,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Update the task only if all validations pass
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: title,
      description: descriptionController.text,
      dueDate: dueDate.toLocal(),
      priority: priority.toInt(),
      isCompleted: widget.task.isCompleted,
    );

    taskController.updateTask(updatedTask);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editTaskTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.title,
                  enabledBorder: kEnabledBorder,
                  focusedBorder: kFocusedBorder,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppStrings.description,
                  enabledBorder: kEnabledBorder,
                  focusedBorder: kFocusedBorder,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(
                  labelText: AppStrings.dueDate,
                  enabledBorder: kEnabledBorder,
                  focusedBorder: kFocusedBorder,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dueDateController.text =
                        pickedDate.toIso8601String().split('T').first;
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority Level: ${priority.toInt()}',
                      style: kBodyText2,
                    ),
                    Slider(
                      activeColor: Colors.blue,
                      thumbColor: Colors.blue,
                      value: priority,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: priority.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          priority = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: device.height * 0.15),
              SizedBox(
                width: device.width * 0.5,
                height: device.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent),
                  onPressed: _validateAndUpdateTask,
                  child: Text(
                    AppStrings.updateTask,
                    style: kBodyText2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
