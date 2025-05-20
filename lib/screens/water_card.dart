import 'package:flutter/material.dart';

class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          color: const Color(0xFA86C3FF),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row (Water + More)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Water: 6 / 24 fl oz',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'More',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Glasses row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                if (index == 0) {
                  // Filled glass
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child:
                            Icon(Icons.wine_bar_rounded, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      const Text('6 fl oz',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  );
                } else if (index == 1) {
                  // Plus glass
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('6 fl oz',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  );
                } else {
                  // Empty glass
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('6 fl oz',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
