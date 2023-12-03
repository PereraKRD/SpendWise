import 'package:flutter/material.dart';
import 'package:spendwise/log_in.dart';
import 'package:spendwise/screens/Home_Screen.dart';
import 'package:spendwise/screens/transaction_screen.dart';
import 'package:spendwise/services/auth_service.dart';
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
  ];

  var isLogoutLoader = false;
  var authService = AuthService();

  signOut() async {
    setState(() {
      isLogoutLoader = true;
    });
    await authService.signOutUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const LogInView()),
      ),
    );
    setState(() {
      isLogoutLoader = false;
    });
  }

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
