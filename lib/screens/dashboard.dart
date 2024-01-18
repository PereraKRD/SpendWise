import 'package:flutter/material.dart';
import 'package:spendwise/screens/Home_Screen.dart';
import 'package:spendwise/screens/Profile_Screen.dart';
import 'package:spendwise/screens/transaction_screen.dart';
import 'package:spendwise/widgets/bottomNavBar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  var pageViewList = [
    HomeScreen(),
    TransactionScreen(),
    Profile_Page(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: pageViewList[currentIndex],
    );
  }
}
