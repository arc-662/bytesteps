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

  final List<String> dayLabels = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    int currentMonthIndex = DateTime.now().month;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final weeklySteps = controller.weeklySteps;
            final weeklyCalories = controller.weeklyCalories;

            final monthlySteps = controller.monthlySteps;
            final monthlyCalories = controller.monthlyCalories;

            // Check if weekly data is missing
            if (weeklySteps.isEmpty || weeklyCalories.isEmpty) {
              return const Center(
                child: Text(
                  "Weekly data will appear after your steps are saved at 12 PM.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            // Check if monthly data is missing
            if (monthlySteps.isEmpty || monthlyCalories.isEmpty) {
              return const Center(
                child: Text(
                  "Monthly data will be shown once steps data is saved during the month.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final int weeklyBarCount = weeklySteps.length;
            final int monthlyBarCount = currentMonthIndex;

            final weeklyCombinedList = [
              ...weeklySteps,
              ...weeklyCalories.map((c) => c.toInt())
            ];
            final weeklyMaxValue = weeklyCombinedList.isNotEmpty
                ? weeklyCombinedList.reduce((a, b) => a > b ? a : b)
                : 0;

            final monthlyStepsSublist = monthlySteps.length >= monthlyBarCount
                ? monthlySteps.sublist(0, monthlyBarCount)
                : [];
            final monthlyCaloriesSublist =
                monthlyCalories.length >= monthlyBarCount
                    ? monthlyCalories.sublist(0, monthlyBarCount)
                    : [];
            final monthlyCombinedList = [
              ...monthlyStepsSublist,
              ...monthlyCaloriesSublist.map((c) => c.toInt())
            ];
            final monthlyMaxValue = monthlyCombinedList.isNotEmpty
                ? monthlyCombinedList.reduce((a, b) => a > b ? a : b)
                : 0;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Steps & Calories',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        maxY: (weeklyMaxValue * 1.2).toDouble(),
                        barGroups: List.generate(weeklyBarCount, (index) {
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 4,
                            barRods: [
                              BarChartRodData(
                                toY: weeklySteps[index].toDouble(),
                                color: Colors.blue,
                                width: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              BarChartRodData(
                                toY: weeklyCalories[index],
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
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index < weeklyBarCount) {
                                  return SideTitleWidget(
                                    space: 6,
                                    meta: meta,
                                    child: Transform.rotate(
                                      angle: -0.4,
                                      child: Text(
                                        dayLabels[index],
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
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData:
                            FlGridData(show: true, horizontalInterval: 1000),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Monthly Steps & Calories',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 350,
                    child: BarChart(
                      BarChartData(
                        maxY: (monthlyMaxValue * 1.2).toDouble(),
                        barGroups: List.generate(monthlyBarCount, (index) {
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 4,
                            barRods: [
                              BarChartRodData(
                                toY: monthlySteps[index].toDouble(),
                                color: Colors.blue,
                                width: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              BarChartRodData(
                                toY: monthlyCalories[index],
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
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData:
                            FlGridData(show: true, horizontalInterval: 1000),
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
              ),
            );
          }),
        ),
      ),
    );
  }
}
