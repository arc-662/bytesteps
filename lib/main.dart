import 'package:bytesteps/controller.dart';
import 'package:bytesteps/model/workmanager_service.dart';
import 'package:bytesteps/screens/dashboard.dart';
import 'package:bytesteps/screens/login.dart';
import 'package:bytesteps/step_entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  Hive.registerAdapter(StepEntryAdapter());
  await Hive.openBox<StepEntry>('stepsBox');
  await Hive.openBox('cacheBox');

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    saveStepsTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: true,
    ),
  );

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
