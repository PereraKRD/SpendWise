import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinationSelected});
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: NavigationBar(
        backgroundColor: TColor.primary,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        indicatorColor: TColor.secondary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.notifications_sharp, color: Colors.white),
              backgroundColor: TColor.notificationActive,
            ),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2', style: TextStyle(color: Colors.black)),
              child: Icon(Icons.messenger_sharp, color: Colors.white),
              backgroundColor: TColor.notificationActive,
            ),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
