import 'package:flutter/material.dart';
import 'package:vital_sync/views/profile_view.dart';
import 'views/home_view.dart';
import 'main.dart' show SimpleChart;
import 'widgets/navigation_bar_widget.dart';

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    SimpleChart(),
    SimpleChart(), // Placeholder for Analytics, can be replaced
    ProfileView(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: NavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
