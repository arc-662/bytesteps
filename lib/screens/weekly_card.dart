import 'package:bytesteps/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WeeklyTrackerCard extends StatelessWidget {
  WeeklyTrackerCard({super.key});

  // Mapping Dart weekdays (Mon=1,...Sun=7) to your UI index
  final Map<int, int> weekdayToIndex = {
    1: 5, // Monday
    2: 6, // Tuesday
    3: 0, // Wednesday
    4: 1, // Thursday
    5: 2, // Friday
    6: 3, // Saturday
    7: 4, // Sunday
  };

  final List<String> dayLetters = ['W', 'T', 'F', 'S', 'S', 'M', 'T'];
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Future<int> calculateWeeklyAverage() async {
    final box = Hive.box('stepBox');
    int sum = 0;
    int count = 0;

    for (String day in weekdays) {
      final steps = box.get(day, defaultValue: 0);
      if (steps is int && steps > 0) {
        sum += steps;
        count++;
      }
    }

    return count > 0 ? (sum ~/ count) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final int todayWeekday = DateTime.now().weekday;
    final int todayUIIndex = weekdayToIndex[todayWeekday] ?? -1;

    return FutureBuilder<int>(
      future: calculateWeeklyAverage(),
      builder: (context, snapshot) {
        final average = snapshot.data ?? 0;

        return Card(
          elevation: 3,
          color: greyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width * 0.92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Daily average: $average',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: blackColor),
                              ),
                            ),
                            if (index == todayUIIndex)
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: lightBlue,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayLetters[index],
                          style: const TextStyle(
                            color: blackColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
