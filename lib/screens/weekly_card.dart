import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final int todayWeekday = DateTime.now().weekday;
    final int todayUIIndex = weekdayToIndex[todayWeekday] ?? -1;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          color: const Color(0xFA86C3FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Daily average: 1225',
              style: TextStyle(
                color: Colors.white,
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
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                        if (index == todayUIIndex)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dayLetters[index],
                      style: const TextStyle(
                        color: Colors.white,
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
  }
}
