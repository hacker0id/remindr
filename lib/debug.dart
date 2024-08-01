import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Initialize time zones
  NotificationService.init(); // Initialize notifications
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Notification Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              final DateTime now = DateTime.now();
              NotificationService.showNotification(
                id: 0,
                title: 'Test Notification',
                body: 'This is a test notification.',
                scheduledTime: now.add(
                    Duration(seconds: 10)), // Schedule for 10 seconds later
              );
            },
            child: Text('Send Notification'),
          ),
        ),
      ),
    );
  }
}
