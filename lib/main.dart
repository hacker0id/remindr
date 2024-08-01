import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remindr/constants/app_strings.dart';
import 'package:remindr/models/task_model.dart';
import 'package:remindr/services/notification_service.dart';
import 'package:remindr/views/task_list_view.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasksBox');

  runApp(const Remindr());
}

class Remindr extends StatelessWidget {
  const Remindr({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListView(),
    );
  }
}
