import 'package:flutter/material.dart';

class WeeklyTrackerCard extends StatelessWidget {
  WeeklyTrackerCard({super.key});

  int getTodayUIIndex() {
    int weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1:
        return 5; // Monday
      case 2:
        return 6; // Tuesday
      case 3:
        return 0; // Wednesday
      case 4:
        return 1; // Thursday
      case 5:
        return 2; // Friday
      case 6:
        return 3; // Saturday
      case 7:
        return 4; // Sunday
      default:
        return -1;
    }
  }

  final List<String> dayLetters = ['W', 'T', 'F', 'S', 'S', 'M', 'T'];

  @override
  Widget build(BuildContext context) {
    final int todayUIIndex = getTodayUIIndex();

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
            borderRadius: BorderRadius.circular(10)),
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
              // Auto generate 7 days
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
