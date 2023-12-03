import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/utils/icons_list.dart';

class TransactionList extends StatelessWidget {
  TransactionList({
    super.key,
    required this.data,
  });
  final dynamic data;

  var appIcon = AppIcons();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
    String formatedDate = DateFormat('d MMM hh:mm a').format(date);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFD4CEFE), offset: Offset(0, 7), blurRadius: 15)
          ]),
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: data['type'] == 'Expense'
                      ? Color(0xffFFE5F3)
                      : Color.fromARGB(
                          255, 229, 255, 250), //data['type'] Color(0xffFFE5F3),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                  child: FaIcon(
                      appIcon.getExpenseCategoryIcons("${data['category']}")))),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data['title']}",
                      maxLines: 1,
                      style: TextStyle(
                          color: Color(0xff5C5C5C),
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${data['type'] == 'Expense' ? '-' : '+'} ${data['amount']}",
                      maxLines: 1,
                      style: TextStyle(
                          color: data['type'] == 'Expense'
                              ? Colors.red
                              : Color(0xff02C487),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Balance",
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xff5C5C5C),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${data['remainingAmount']}",
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xff5C5C5C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  "$formatedDate",
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xff5C5C5C),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
