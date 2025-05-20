import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bytesteps/controller.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight - 1),
              child: AppBar(
                backgroundColor: Color(0xFA86C3FF),
                bottom: TabBar(
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: "Daily"),
                    Tab(text: "Weekly"),
                    Tab(text: "Monthly"),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                // dailyChart(),
                // weeklyChart(),
                // monthlyChart(),
              ],
            )));
  }
}

  // Widget legendRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       LegendDot(color: Colors.blue, label: 'Steps'),
  //       SizedBox(width: 12),
  //       LegendDot(color: Colors.orange, label: 'Calories'),
  //     ],
  //   );
  // }

//   Widget dailyChart() {
//     final steps = controller.stepCount.value.toDouble();
//     final calories = controller.calories.value;

//     final isStepsValid = steps.isFinite && steps >= 0;
//     final isCaloriesValid = calories.isFinite && calories >= 0;

//     final safeSteps = isStepsValid ? steps : 0.0;
//     final safeCalories = isCaloriesValid ? calories : 0.0;

//     final maxVal = (safeSteps > safeCalories ? safeSteps : safeCalories) + 100;
//     final safeMaxY = maxVal.isFinite ? maxVal : 1000;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           legendRow(),
//           SizedBox(height: 16),
//           BarChart(
//             BarChartData(
//               maxY: safeMaxY.toDouble(),
//               barGroups: [
//                 BarChartGroupData(x: 0, barRods: [
//                   BarChartRodData(
//                     toY: safeSteps,
//                     color: Colors.blue,
//                     width: 20,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   BarChartRodData(
//                     toY: safeCalories,
//                     color: Colors.orange,
//                     width: 20,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ])
//               ],
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       if (!value.isFinite || value.toInt() != 0) {
//                         return SizedBox.shrink();
//                       }
//                       return Text("Steps / Calories");
//                     },
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                 ),
//               ),
//               barTouchData: BarTouchData(enabled: true),
//               gridData: FlGridData(show: true),
//               borderData: FlBorderData(show: false),
//               alignment: BarChartAlignment.spaceEvenly,
//               groupsSpace: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget weeklyChart() {
//     final steps = controller.weeklySteps;
//     final calories = controller.weeklyCalories;

//     if (steps.length < 7 || calories.length < 7) {
//       return Center(child: Text("No weekly data available"));
//     }

//     final allValues = [...steps.map((e) => e.toDouble()), ...calories]
//         .where((e) => e.isFinite && e >= 0)
//         .toList();

//     final maxVal =
//         allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 1000;
//     final safeMaxY = maxVal + 500;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           legendRow(),
//           SizedBox(height: 16),
//           BarChart(
//             BarChartData(
//               maxY: safeMaxY.toDouble(),
//               barGroups: List.generate(7, (index) {
//                 return BarChartGroupData(x: index, barRods: [
//                   BarChartRodData(
//                     toY: steps[index].toDouble().isFinite
//                         ? steps[index].toDouble()
//                         : 0.0,
//                     color: Colors.blue,
//                     width: 10,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                   BarChartRodData(
//                     toY: calories[index].isFinite ? calories[index] : 0.0,
//                     color: Colors.orange,
//                     width: 10,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ]);
//               }),
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       const days = [
//                         'Mon',
//                         'Tue',
//                         'Wed',
//                         'Thu',
//                         'Fri',
//                         'Sat',
//                         'Sun'
//                       ];
//                       if (!value.isFinite ||
//                           value < 0 ||
//                           value >= days.length) {
//                         return SizedBox.shrink();
//                       }
//                       return Text(days[value.toInt()]);
//                     },
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                 ),
//               ),
//               barTouchData: BarTouchData(enabled: true),
//               gridData: FlGridData(show: true),
//               borderData: FlBorderData(show: false),
//               groupsSpace: 8,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget monthlyChart() {
//     final steps = controller.monthlySteps;
//     final calories = controller.monthlyCalories;

//     if (steps.length < 30 || calories.length < 30) {
//       return Center(child: Text("No monthly data available"));
//     }

//     final allValues = [...steps.map((e) => e.toDouble()), ...calories]
//         .where((e) => e.isFinite && e >= 0)
//         .toList();

//     final maxVal =
//         allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 1000;
//     final safeMaxY = maxVal + 500;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           legendRow(),
//           SizedBox(height: 16),
//           BarChart(
//             BarChartData(
//               maxY: safeMaxY.toDouble(),
//               barGroups: List.generate(30, (index) {
//                 final stepVal = steps[index].toDouble().isFinite
//                     ? steps[index].toDouble()
//                     : 0.0;
//                 final calorieVal =
//                     calories[index].isFinite ? calories[index] : 0.0;

//                 return BarChartGroupData(x: index, barRods: [
//                   BarChartRodData(
//                     toY: stepVal,
//                     color: Colors.blue,
//                     width: 4,
//                     borderRadius: BorderRadius.circular(1),
//                   ),
//                   BarChartRodData(
//                     toY: calorieVal,
//                     color: Colors.orange,
//                     width: 4,
//                     borderRadius: BorderRadius.circular(1),
//                   ),
//                 ]);
//               }),
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 5,
//                     getTitlesWidget: (value, meta) {
//                       if (!value.isFinite || value < 0 || value >= 30) {
//                         return SizedBox.shrink();
//                       }
//                       return Text("Day ${value.toInt() + 1}",
//                           style: TextStyle(fontSize: 10));
//                     },
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                 ),
//               ),
//               barTouchData: BarTouchData(enabled: true),
//               gridData: FlGridData(show: true),
//               borderData: FlBorderData(show: false),
//               groupsSpace: 4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LegendDot extends StatelessWidget {
//   final Color color;
//   final String label;
//   const LegendDot({required this.color, required this.label, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(width: 12, height: 12, color: color),
//         SizedBox(width: 4),
//         Text(label),
//       ],
//     );
//   }
// }
