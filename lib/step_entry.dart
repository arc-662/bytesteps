import 'package:hive/hive.dart';

part 'step_entry.g.dart';

@HiveType(typeId: 1) // Use a unique typeId
class StepEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int stepCount;

  StepEntry({required this.date, required this.stepCount});
}
