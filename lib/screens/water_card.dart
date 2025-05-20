import 'package:flutter/material.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  int filledGlasses = 0;
  final int totalGlasses = 4;
  final int glassVolume = 6; // in fl oz

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
              children: [
                Text(
                  'Water: ${filledGlasses * glassVolume} / ${totalGlasses * glassVolume} fl oz',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => {
                    setState(() {
                      filledGlasses = 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Water intake is now 0")));
                    })
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Glasses row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(totalGlasses, (index) {
                if (index < filledGlasses) {
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
                        child: const Icon(
                          Icons.wine_bar_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$glassVolume fl oz',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                } else if (index == filledGlasses) {
                  // Plus glass
                  return GestureDetector(
                    onTap: () {
                      if (filledGlasses < totalGlasses) {
                        setState(() {
                          filledGlasses++;
                        });
                      }
                    },
                    child: Column(
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$glassVolume fl oz',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
                      Text(
                        '$glassVolume fl oz',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
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
