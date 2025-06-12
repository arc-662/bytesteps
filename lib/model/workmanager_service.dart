import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytesteps/step_entry.dart';

const String saveStepsTask = "saveStepsTask";

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == saveStepsTask) {
      final now = DateTime.now();
      final isNight = now.hour == 12 && now.minute < 20;

      if (!isNight) {
        print('⏳ Skipped: Not 12 PM yet (${now.hour}:${now.minute})');
        return Future.value(true);
      }

      final box = Hive.box<StepEntry>('stepsBox');
      final cacheBox = Hive.box('cacheBox');
      final int savedSteps = cacheBox.get('latestStepCount', defaultValue: 0);

      final existing = box.values.firstWhere(
        (entry) => isSameDate(entry.date, now),
        orElse: () => StepEntry(date: now, stepCount: savedSteps),
      );

      if (existing.key != null) {
        existing.stepCount = savedSteps;
        await existing.save();
      } else {
        await box.add(StepEntry(date: now, stepCount: savedSteps));
      }

      print('✅ Steps auto-saved at 12 PM: $savedSteps');
    }
    return Future.value(true);
  });
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
