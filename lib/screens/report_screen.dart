import 'package:bytesteps/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Steps & Calories Report'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monthly Steps',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: Obx(() {
                return BarChart(
                  BarChartData(
                    maxY: controller.monthlySteps.value.fold<double>(
                            0, (prev, e) => e > prev ? e.toDouble() : prev) *
                        1.2,
                    barGroups:
                        List.generate(controller.monthlySteps.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: controller.monthlySteps[index].toDouble(),
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(4),
                            width: 12,
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text('Month'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 4,
                          getTitlesWidget: (value, meta) {
                            final intVal = value.toInt();
                            String monthLabel = '';
                            switch (intVal) {
                              case 0:
                                monthLabel = 'Jan';
                                break;
                              case 4:
                                monthLabel = 'May';
                                break;
                              case 8:
                                monthLabel = 'Sep';
                                break;
                              case 12:
                                monthLabel = 'Jan';
                                break;
                              case 16:
                                monthLabel = 'May';
                                break;
                              case 20:
                                monthLabel = 'Sep';
                                break;
                              case 24:
                                monthLabel = 'Jan';
                                break;
                              case 28:
                                monthLabel = 'May';
                                break;
                              default:
                                monthLabel = '';
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(monthLabel,
                                  style: TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text('Steps'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2000,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 2000),
                    borderData: FlBorderData(show: false),
                  ),
                );
              }),
            ),
            SizedBox(height: 32),
            Text(
              'Monthly Calories Burned',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: Obx(() {
                return LineChart(
                  LineChartData(
                    maxY: controller.monthlyCalories.value
                            .fold<double>(0, (prev, e) => e > prev ? e : prev) *
                        1.2,
                    minY: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          controller.monthlyCalories.length,
                          (index) => FlSpot(index.toDouble(),
                              controller.monthlyCalories[index]),
                        ),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text('Month'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final intVal = value.toInt();
                            String monthLabel = '';
                            switch (intVal) {
                              case 0:
                                monthLabel = 'Jan';
                                break;
                              case 5:
                                monthLabel = 'Jun';
                                break;
                              case 10:
                                monthLabel = 'Nov';
                                break;
                              case 15:
                                monthLabel = 'Apr';
                                break;
                              case 20:
                                monthLabel = 'Sep';
                                break;
                              case 25:
                                monthLabel = 'Feb';
                                break;
                              default:
                                monthLabel = '';
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(monthLabel,
                                  style: TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text('Calories'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 100,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 100),
                    borderData: FlBorderData(show: false),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
