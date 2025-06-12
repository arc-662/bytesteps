import 'package:bytesteps/controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatelessWidget {
  final DashboardController controller = Get.find();

  ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Monthly Report')),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Steps per Month',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Obx(() {
                    try {
                      final monthlySteps = List<int>.generate(12, (i) {
                        return i < controller.monthlySteps.length
                            ? controller.monthlySteps[i]
                            : 0;
                      });

                      final bool noData =
                          monthlySteps.every((step) => step == 0);

                      if (noData) {
                        // Show friendly message for no data yet (first app open)
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions_walk,
                                  size: 80,
                                  color: Colors.blueGrey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No step data yet',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start walking and your steps will appear here.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return AspectRatio(
                        aspectRatio: 1.7,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY:
                                (monthlySteps.reduce((a, b) => a > b ? a : b) *
                                        1.2)
                                    .ceilToDouble(),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const months = [
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
                                    return SideTitleWidget(
                                      meta: meta,
                                      fitInside: const SideTitleFitInsideData(
                                        enabled: false,
                                        distanceFromEdge: 0,
                                        parentAxisSize: 0,
                                        axisPosition: 0,
                                      ),
                                      child: Text(
                                        value.toInt() >= 0 && value.toInt() < 12
                                            ? months[value.toInt()]
                                            : '',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                  interval: 1,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, interval: 1000),
                              ),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(12, (index) {
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: monthlySteps[index].toDouble(),
                                    color: Colors.blueAccent,
                                    width: 16,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    } catch (e) {
                      return Center(
                        child: Text(
                          'Error loading data: ${e.toString()}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
