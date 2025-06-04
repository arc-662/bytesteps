import 'package:bytesteps/step_entry.dart';
import 'package:get/get.dart';
import 'package:bytesteps/screens/steps_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardController extends GetxController {
  DashboardCard dashboardCard = DashboardCard();
  // Declaring variables
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
  List<int> get weeklySteps =>
      getLast7DaysSteps().map((entry) => entry.stepCount).toList();

  List<int> get monthlySteps =>
      getLast30DaysSteps().map((entry) => entry.stepCount).toList();
  //
  // list to store the list of Steps Goal
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
    scheduleDailyStepSave();
    super.onInit();
  }

  // Method to reset all set values
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
    double meters = stepCount.value * stepLength.value;
    distance.value = meters / 1609.34;
    updateCalories();
  }

  // Method to calculate Calories
  void updateCalories() {
    double kilometers = distance.value * 1.6034;
    calories.value = kilometers * weight.value * 1.036;
  }

  // Method to schedule the timer to save today's steps in box exactly at 11:59
  void scheduleDailyStepSave() {
    final now = DateTime.now();
    final targetTime = DateTime(now.year, now.month, now.day, 23, 59);
    Duration delay;

    if (now.isBefore(targetTime)) {
      delay = targetTime.difference(now);
    } else {
      // If it's already past 11:59 today, schedule for tomorrow
      final tomorrowTarget = targetTime.add(Duration(days: 1));
      delay = tomorrowTarget.difference(now);
    }

    Future.delayed(delay, () async {
      await saveDailySteps(stepCount.value);
      // Re-schedule for the next day
      scheduleDailyStepSave();
    });
  }

  // Method to save Daily Steps with date to Hive
  Future<void> saveDailySteps(int steps) async {
    final box = Hive.box<StepEntry>('stepsBox');
    DateTime today = DateTime.now();

    // Putting check if entry for today already exists
    final existing = box.values.firstWhere(
      (entry) => isSameDate(entry.date, today),
      orElse: () => StepEntry(date: today, stepCount: 0),
    );

    if (existing.key != null) {
      existing.stepCount = steps;
      existing.save();
    } else {
      box.add(StepEntry(date: today, stepCount: steps));
    }
  }

  // Method to compare date with today's date
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Method to get last 7 day's steps from Hive
  List<StepEntry> getLast7DaysSteps() {
    final box = Hive.box<StepEntry>('stepsBox');
    final DateTime now = DateTime.now();
    final DateTime weekAgo = now.subtract(Duration(days: 7));

    return box.values.where((entry) => entry.date.isAfter(weekAgo)).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // sorting and updating
  }

  // Method to get last 30 day's steps from Hive
  List<StepEntry> getLast30DaysSteps() {
    final box = Hive.box<StepEntry>('stepsBox');
    final DateTime now = DateTime.now();
    final DateTime monthAgo = now.subtract(Duration(days: 30));

    return box.values.where((entry) => entry.date.isAfter(monthAgo)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<double> get weeklyCalories {
    return getLast7DaysSteps().map((entry) {
      double miles = entry.stepCount * stepLength.value / 1609.34;
      double kilometers = miles * 1.6034;
      return kilometers * weight.value * 1.036;
    }).toList();
  }

  List<double> get monthlyCalories {
    return getLast30DaysSteps().map((entry) {
      double miles = entry.stepCount * stepLength.value / 1609.34;
      double kilometers = miles * 1.6034;
      return kilometers * weight.value * 1.036;
    }).toList();
  }
}
