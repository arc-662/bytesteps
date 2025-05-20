import 'package:bytesteps/screens/health_screen.dart';
import 'package:bytesteps/screens/setting_screen.dart';
import 'package:bytesteps/screens/home_screen.dart';
import 'package:bytesteps/screens/test_report.dart';
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
    TestReport(),
    HealthScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFE0C3FC),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white60,
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
        title: Text("ByteSteps"),
        centerTitle: true,
        backgroundColor: Color(0xFA86C3FF),
        titleTextStyle: TextStyle(
          letterSpacing: 1,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
    );
  }
}
