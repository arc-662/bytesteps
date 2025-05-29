import 'package:bytesteps/colors.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  int filledGlasses = 0;
  int waterGoal = 24; // default goal in fl oz
  final int glassVolume = 6;

  void _showWaterGoalPickerDialog() async {
    int selectedValue = waterGoal;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Set Daily Water Goal",
            style: TextStyle(color: blackColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select amount (in fl oz)"),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return NumberPicker(
                    value: selectedValue,
                    minValue: 6,
                    maxValue: 120,
                    step: 6,
                    axis: Axis.horizontal,
                    onChanged: (value) {
                      setDialogState(() => selectedValue = value);
                    },
                    textStyle: const TextStyle(color: Colors.purple),
                    selectedTextStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  waterGoal = selectedValue;
                  filledGlasses = 0; // reset on new goal
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Daily goal set to $selectedValue fl oz")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalGlasses = waterGoal ~/ glassVolume;
    double progress = (filledGlasses * glassVolume) / waterGoal;
    progress = progress.clamp(0.0, 1.0);

    return Card(
      color: greyColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.19,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row (Water + Set + Reset)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water: ${filledGlasses * glassVolume} / $waterGoal fl oz',
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: _showWaterGoalPickerDialog,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          'Set',
                          style: TextStyle(color: blackColor, fontSize: 14),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          filledGlasses = 0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Water intake is now 0")),
                        );
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: blackColor, fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 12),
            // Progress bar
            Center(
              child: SizedBox(
                height: 12.0,
                width: 300.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12.0,
                    backgroundColor: Colors.grey.shade300,
                    color: lightBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Glasses row
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(totalGlasses, (index) {
                    if (index < filledGlasses) {
                      return _buildGlass(
                          filled: true, index: index, plus: false);
                    } else if (index == filledGlasses) {
                      return _buildGlass(
                          filled: false, index: index, plus: true);
                    } else {
                      return _buildGlass(
                          filled: false, index: index, plus: false);
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlass(
      {required bool filled, required int index, required bool plus}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: plus && filledGlasses < (waterGoal ~/ glassVolume)
            ? () {
                setState(() {
                  filledGlasses++;
                });
              }
            : null,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                color: filled ? lightBlue : null,
                border: Border.all(color: blackColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: filled
                    ? const Icon(Icons.wine_bar_rounded, color: Colors.white)
                    : plus
                        ? const Text(
                            '+',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$glassVolume fl oz',
              style: const TextStyle(
                color: blackColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
