import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/widgets/Category_List.dart';
import 'package:spendwise/widgets/tab_bar_view.dart';
import 'package:spendwise/widgets/time_line_month.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var monthYear = "";
  var category = "All";

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthYear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Transactions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Column(
          children: [
            TimeLineWithMonth(
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    monthYear = value;
                  });
                }
              },
            ),
            CategoryList(onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            }),
            Tabbar_View(
              category: category,
              monthYear: monthYear,
            ),
          ],
        ));
  }
}
