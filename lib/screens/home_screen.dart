import 'package:bytesteps/screens/dashboard_card.dart';
import 'package:bytesteps/screens/water_card.dart';
import 'package:bytesteps/screens/weekly_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity, // full width usage
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFA86C3FF), Color(0xFFE0C3FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                DashboardCard(),
                WeeklyTrackerCard(),
                WaterTrackerCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
