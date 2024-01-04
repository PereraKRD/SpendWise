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
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: NavigationBar(
        backgroundColor: TColor.primary,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              size: 35,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 35,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.monetization_on_outlined,
              size: 35,
            ),
            icon: Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 35,
            ),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              size: 35,
            ),
            icon: Icon(
              Icons.person_outlined,
              color: Colors.white,
              size: 35,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
