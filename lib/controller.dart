import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:bytesteps/screens/steps_card.dart';

class DashboardController extends GetxController {
  DashboardCard dashboardCard = DashboardCard();

  final RxList<int> weeklySteps =
      <int>[359, 1962, 3565, 5168, 6771, 8374, 9999].obs;
  final RxList<double> weeklyCalories =
      <double>[120.5, 235.0, 348.3, 462.7, 589.9, 645.2, 750.0].obs;

  final RxList<int> monthlySteps = <int>[
    512,
    835,
    1102,
    1324,
    1580,
    1867,
    2104,
    2390,
    2678,
    2980,
    3256,
    3534,
    3860,
    4125,
    4378,
    4650,
    4912,
    5190,
    5476,
    5760,
    6034,
    6320,
    6587,
    6875,
    7160,
    7435,
    7710,
    8450,
    9220,
    9999,
  ].obs;

  final RxList<double> monthlyCalories = <double>[
    120.5,
    138.0,
    152.3,
    165.7,
    178.9,
    192.6,
    205.3,
    219.0,
    231.4,
    248.6,
    263.5,
    278.9,
    294.2,
    309.8,
    325.0,
    342.7,
    359.4,
    376.1,
    393.7,
    410.5,
    428.0,
    445.6,
    463.2,
    481.9,
    500.0,
    518.7,
    580.0,
    645.3,
    698.9,
    750.0
  ].map((e) => e.isFinite ? e : 0.0).toList().obs;

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
  // final RxInt isMax

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

  Timer? _midnightTimer;

  @override
  void onInit() {
    super.onInit();
    startMidnightSaver();
  }

  void startMidnightSaver() {
    print("Mid-Night Counter is Started");
    _midnightTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        saveStepsToHive();
      }
    });
  }

  void saveStepsToHive() {
    final box = Hive.box('stepBox');
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final String weekday = _weekdayName(yesterday.weekday);

    box.put(weekday, stepCount.value);
    print("✅ Saved ${stepCount.value} steps for $weekday");

    // Optional: Reset today's steps
    stepCount.value = 0;
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  void resetProgress() {
    progress.value = 0.0;
    stepCount.value = 0;
    isStarted.value = false;
    distance.value = 0.0;
    calories.value = 0.0;
    elapsedTime.value = "0";
  }

  void updateDistance() {
    double meters = stepCount.value * stepLength.value;
    distance.value = meters / 1609.34;
    updateCalories();
  }

  void updateCalories() {
    double kilometers = distance.value * 1.6034;
    calories.value = kilometers * weight.value * 1.036;
  }

  @override
  void onClose() {
    _midnightTimer?.cancel();
    super.onClose();
  }
}
