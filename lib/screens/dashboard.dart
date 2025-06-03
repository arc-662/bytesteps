import 'package:bytesteps/colors.dart';
import 'package:bytesteps/screens/health_screen.dart';
import 'package:bytesteps/screens/report_screen.dart';
import 'package:bytesteps/screens/setting_screen.dart';
import 'package:bytesteps/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
// List to show all screen widgets
  final List<Widget> screens = [
    HomeScreen(),
    ReportScreen(),
    HealthScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: greyColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'More'),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "ByteSteps",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: greyColor,
        titleTextStyle: TextStyle(
          letterSpacing: 1,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
    );
  }
}
