import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bytesteps/controller.dart';
import 'package:bytesteps/screens/dashboard.dart';
import 'package:bytesteps/screens/login.dart';
import 'package:bytesteps/step_entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('dailyAvg');
  Hive.registerAdapter(StepEntryAdapter());
  await Hive.openBox<StepEntry>('stepsBox');
  await Hive.openBox('userBox');
  await AndroidAlarmManager.initialize();

  // to Check if user has already filled info
  final box = Hive.box('userBox');
  bool isUserInfoSaved = box.get('isUserInfoSaved', defaultValue: false);

  Get.put(DashboardController());
  runApp(MyApp(showDashboard: isUserInfoSaved));
}

class MyApp extends StatelessWidget {
  final bool showDashboard;

  const MyApp({super.key, required this.showDashboard});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bytesteps',
      home: showDashboard ? Dashboard() : UserInfoScreen(),
    );
  }
}
