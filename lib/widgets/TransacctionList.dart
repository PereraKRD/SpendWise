import 'package:flutter/cupertino.dart';
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
      child: CupertinoContextMenu.builder(
        actions: <Widget>[
          CupertinoContextMenuAction(
            onPressed: () {
              //add a confirmation
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('Confirm Edit'),
                    content:
                        Text('Are you sure you want to edit this transaction?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          // Implement edit functionality here
                        },
                        child: Text('Yes'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
            trailingIcon: CupertinoIcons.pencil,
            child: const Text('Edit'),
          ),
          CupertinoContextMenuAction(
            onPressed: () {
              //add a confirmation
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text(
                        'Are you sure you want to delete this transaction?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          // Implement delete functionality here
                        },
                        child: Text('Yes'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.delete,
            child: const Text('Delete'),
          ),
        ],
        builder: (BuildContext context, Animation<double> animation) {
          return Container(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFD4CEFE),
                        offset: Offset(0, 7),
                        blurRadius: 15)
                  ]),
              child: Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: data['type'] == 'Expense'
                              ? Color(0xffFFE5F3)
                              : Color.fromARGB(255, 229, 255,
                                  250), //data['type'] Color(0xffFFE5F3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: FaIcon(appIcon.getExpenseCategoryIcons(
                              "${data['category']}")))),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
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
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
