import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindr/constants/app_strings.dart';
import 'package:remindr/constants/font_sizes.dart';
import 'package:remindr/constants/text_field_decoration.dart';
import 'package:remindr/models/task_model.dart';
import 'package:remindr/controllers/task_controller.dart';
import 'package:remindr/views/task_list_view.dart';
import 'package:uuid/uuid.dart';

class TaskCreationView extends StatefulWidget {
  const TaskCreationView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskCreationViewState createState() => _TaskCreationViewState();
}

class _TaskCreationViewState extends State<TaskCreationView> {
  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final Uuid uuid = const Uuid();
  double priority = 1;

  void _validateAndAddTask() {
    final title = titleController.text.trim();
    final dueDateText = dueDateController.text;

    if (title.isEmpty) {
      Get.snackbar(
        AppStrings.validationErr,
        AppStrings.editTaskTitle,
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
        AppStrings.emptyDueDateMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Add the task only if all validations pass
    taskController.addTask(TaskModel(
      id: uuid.v4(),
      title: title,
      description: descriptionController.text,
      dueDate: dueDate.toLocal(),
      priority: priority.toInt(),
    ));

    Get.to(TaskListView());
    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.createNewTask),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: device.height * 0.025),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.title,
                  enabledBorder: kEnabledBorder,
                  focusedBorder: kFocusedBorder,
                ),
              ),
              SizedBox(height: device.height * 0.035),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppStrings.description,
                  enabledBorder: kEnabledBorder,
                  focusedBorder: kFocusedBorder,
                ),
              ),
              SizedBox(height: device.height * 0.035),
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
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                  onSurface: Colors.blue,
                                  onPrimary: Colors.white,
                                  primary: Colors.blueAccent)),
                          child: child!,
                        );
                      });
                  if (pickedDate != null) {
                    dueDateController.text = pickedDate
                        .toIso8601String()
                        .split('T')
                        .first; // used to remove the time from diplaying
                  }
                },
              ),
              SizedBox(height: device.height * 0.035),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority Level : ${priority.toInt()}',
                      style: kBodyText3,
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
                  onPressed: _validateAndAddTask,
                  child: Text(
                    AppStrings.addTask,
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
