import 'package:flutter/material.dart';
import 'package:spendwise/widgets/TransactionListForTabs.dart';

class Tabbar_View extends StatelessWidget {
  const Tabbar_View(
      {super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TranscationListForTab(
                  category: category,
                  type: 'Expense',
                  monthYear: monthYear,
                ),
                TranscationListForTab(
                  category: category,
                  type: 'Income',
                  monthYear: monthYear,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
