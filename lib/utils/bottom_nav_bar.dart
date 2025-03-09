import 'package:ekawi/common/home_page.dart';
import 'package:ekawi/screens/ai_recommendations_page.dart'; // Import the new page
import 'package:ekawi/screens/analytics_page.dart';
import 'package:ekawi/screens/energy_usage.dart';
import 'package:ekawi/screens/facility_page.dart';
import 'package:ekawi/screens/reports_page.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Add the AI Recommendations page to the list of pages
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    FacilityPage(),
    EnergyUsageGraph(),
    AIRecommendationsScreen(),
    DeviceUsage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Facility History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology), // You can change the icon
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}