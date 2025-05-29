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
    );
  }
}
