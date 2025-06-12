import 'package:bytesteps/alarm_services.dart';
import 'package:bytesteps/step_entry.dart';
import 'package:get/get.dart';
import 'package:bytesteps/screens/steps_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardController extends GetxController {
  DashboardCard dashboardCard = DashboardCard();

  // Reactive variables
  final RxBool isStarted = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxDouble distance = 0.0.obs;
  final RxDouble stepLength = 0.75.obs;
  final RxDouble weight = 72.0.obs;
  final RxDouble calories = 0.0.obs;
  final RxString elapsedTime = "0".obs;
  final RxInt stepCount = 0.obs;
  final RxInt baseStepCount = 0.obs;
  final RxInt selectedGoal = 1000.obs;

  // Reactive RxList for StepEntries from Hive box
  final RxList<StepEntry> _stepEntries = <StepEntry>[].obs;

  // Expose reactive step counts lists derived from _stepEntries
  RxList<int> weeklySteps = <int>[].obs;
  RxList<int> monthlySteps = <int>[].obs;

  // Similarly, reactive calories for week and month
  RxList<double> weeklyCalories = <double>[].obs;
  RxList<double> monthlyCalories = <double>[].obs;

  // List for goals
  final List<int> goals = [
    1000,
    2000,
    3000,
    4000,
    5000,
    6000,
    7000,
    8000,
    9000
  ];

  @override
  void onInit() {
    super.onInit();
    _initStepEntries();
  }

  Future<void> checkAlarmPermissions() async {
    if (await AlarmPermission.canScheduleExactAlarms()) {
    } else {
      AlarmPermission.requestExactAlarmPermission();
    }
  }

  // Initialize the reactive list from Hive and setup listener on Hive box updates
  Future<void> _initStepEntries() async {
    final box = await Hive.openBox<StepEntry>('stepsBox');
    // Initialize from existing box values sorted by date
    _updateStepEntries(box.values.toList());
    // Listen to Hive box changes and update reactive list accordingly
    box.watch().listen((event) {
      _updateStepEntries(box.values.toList());
    });
  }

  void _updateStepEntries(List<StepEntry> entries) {
    entries.sort((a, b) => a.date.compareTo(b.date));
    _stepEntries.assignAll(entries); // update reactive list with latest
    // Update derived step counts and calories
    _updateWeeklyMonthlyData();
  }

  void _updateWeeklyMonthlyData() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    // Filter entries for last 7 days
    final last7days =
        _stepEntries.where((e) => e.date.isAfter(weekAgo)).toList();
    weeklySteps.assignAll(last7days.map((e) => e.stepCount));
    weeklyCalories.assignAll(last7days.map((entry) {
      final miles = entry.stepCount * stepLength.value / 1609.34;
      final kilometers = miles * 1.6034;
      return kilometers * weight.value * 1.036;
    }));

    // Filter entries for last 30 days
    final last30days =
        _stepEntries.where((e) => e.date.isAfter(monthAgo)).toList();
    monthlySteps.assignAll(last30days.map((e) => e.stepCount));
    monthlyCalories.assignAll(last30days.map((entry) {
      final miles = entry.stepCount * stepLength.value / 1609.34;
      final kilometers = miles * 1.6034;
      return kilometers * weight.value * 1.036;
    }));
  }

  // Method to reset all values
  void resetProgress() {
    progress.value = 0.0;
    stepCount.value = 0;
    isStarted.value = false;
    distance.value = 0.0;
    calories.value = 0.0;
    elapsedTime.value = "0";
  }

  // Method to update distance
  void updateDistance() {
    final meters = stepCount.value * stepLength.value;
    distance.value = meters / 1609.34;
    updateCalories();
  }

  // Method to calculate calories
  void updateCalories() {
    final kilometers = distance.value * 1.6034;
    calories.value = kilometers * weight.value * 1.036;
  }
}
