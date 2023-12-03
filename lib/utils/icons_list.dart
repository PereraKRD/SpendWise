import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      "name": "Gas Filling",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name": "Groceries",
      "icon": FontAwesomeIcons.bagShopping,
    },
    {
      "name": "Dining",
      "icon": FontAwesomeIcons.utensils,
    },
    {
      "name": "Entertainment",
      "icon": FontAwesomeIcons.heart,
    },
    {"name": "Transportation", "icon": FontAwesomeIcons.car},
    {"name": "Health", "icon": FontAwesomeIcons.kitMedical},
    {"name": "Education", "icon": FontAwesomeIcons.book},
    {"name": "Pets", "icon": FontAwesomeIcons.dog},
    {"name": "Home", "icon": FontAwesomeIcons.house},
    {"name": "Gifts", "icon": FontAwesomeIcons.gift},
    {"name": "Other", "icon": FontAwesomeIcons.dollarSign},
    {"name": "Miscellaneous", "icon": FontAwesomeIcons.circle},
  ];
  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category['name'] == categoryName,
        orElse: () => {"icon": FontAwesomeIcons.circle});
    return category['icon'];
  }
}
