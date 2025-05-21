import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  ReportScreen({super.key});

  final List<String> monthLabels = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    int currentMonthIndex = DateTime.now().month; // 1-based index

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final steps = controller.monthlySteps;
            final calories = controller.monthlyCalories;

            final int barCount = currentMonthIndex;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Steps & Calories',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 350,
                  child: BarChart(
                    BarChartData(
                      maxY: ([
                                ...steps.sublist(0, barCount),
                                ...calories
                                    .sublist(0, barCount)
                                    .map((c) => c.toInt())
                              ].reduce((a, b) => a > b ? a : b) *
                              1.2)
                          .toDouble(),
                      barGroups: List.generate(barCount, (index) {
                        return BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: steps[index].toDouble(),
                              color: Colors.blue,
                              width: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            BarChartRodData(
                              toY: calories[index],
                              color: Colors.orange,
                              width: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1000,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) =>
                                Text(value.toInt().toString()),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < currentMonthIndex) {
                                return SideTitleWidget(
                                  space: 6,
                                  meta: meta,
                                  child: Transform.rotate(
                                    angle: -0.4,
                                    child: Text(
                                      monthLabels[index],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 1000,
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.square, color: Colors.blue, size: 14),
                    SizedBox(width: 4),
                    Text("Steps", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 16),
                    Icon(Icons.square, color: Colors.orange, size: 14),
                    SizedBox(width: 4),
                    Text("Calories", style: TextStyle(fontSize: 14)),
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
