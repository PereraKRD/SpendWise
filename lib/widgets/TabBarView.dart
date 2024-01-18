import 'package:flutter/material.dart';
import 'package:spendwise/widgets/TransactionListForTabs.dart';

class Tabbar_View extends StatefulWidget {
  Tabbar_View({super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;

  @override
  State<Tabbar_View> createState() => _Tabbar_ViewState();
}

class _Tabbar_ViewState extends State<Tabbar_View> {
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
                  category: widget.category,
                  type: 'Expense',
                  monthYear: widget.monthYear,
                ),
                TranscationListForTab(
                  category: widget.category,
                  type: 'Income',
                  monthYear: widget.monthYear,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
