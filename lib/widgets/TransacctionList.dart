import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/EditType.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/utils/icons_list.dart';
import 'package:spendwise/widgets/edit_transaction.dart';

class TransactionList extends StatefulWidget {
  TransactionList({
    super.key,
    required this.data,
    required this.userId,
  });
  final dynamic data;
  final String userId;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var appIcon = AppIcons();

  _dialoBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Edit Transaction",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            content: editTransactionForm(
              userId: widget.userId,
              data: widget.data,
            ),
          );
        });
  }

  _dialoBuilder2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Edit Type",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            content: editTypeForm(
              userId: widget.userId,
              data: widget.data,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(widget.data['createdAt']);
    String formatedDate = DateFormat('d MMM hh:mm a').format(date);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return Container(
      child: CupertinoContextMenu.builder(
        actions: <Widget>[
          CupertinoContextMenuAction(
            onPressed: () {
              _dialoBuilder(context);
            },
            trailingIcon: CupertinoIcons.pencil,
            child: const Text('Edit Amount'),
          ),
          CupertinoContextMenuAction(
            onPressed: () {
              _dialoBuilder2(context);
            },
            trailingIcon: CupertinoIcons.pencil,
            child: const Text('Edit Type'),
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
                        onPressed: () async {
                          Navigator.pop(context);
                          int remainingAmount = widget.data['remainingAmount'];
                          int totalExpenses = widget.data['totalExpenses'];
                          int totalIncomes = widget.data['totalIncomes'];
                          int amount = widget.data['amount'];

                          if (widget.data['type'] == 'Income') {
                            remainingAmount -= amount;
                            totalIncomes -= amount;
                          } else {
                            remainingAmount += amount;
                            totalExpenses -= amount;
                          }

                          Navigator.pop(context);

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('transactions')
                              .doc(widget.data['id'])
                              .delete();

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .update({
                            'remainingAmount': remainingAmount,
                            'totalExpenses': totalExpenses,
                            'totalIncomes': totalIncomes,
                            'updatedAt': timestamp,
                          });

                          setState(() {});
                        },
                        child: Text('Yes'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
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
          CupertinoContextMenuAction(
            onPressed: () {
              Navigator.pop(context);
            },
            trailingIcon: CupertinoIcons.xmark_circle,
            child: const Text('Cancel'),
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
                        color: widget.data['type'] == 'Expense'
                            ? Color(0xffFFE5F3)
                            : Color.fromARGB(255, 229, 255, 250),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: FaIcon(
                        appIcon.getExpenseCategoryIcons(
                            "${widget.data['category']}"),
                      ),
                    ),
                  ),
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
                                "${widget.data['title']}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Color(0xff5C5C5C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "${widget.data['type'] == 'Expense' ? '-' : '+'} ${widget.data['amount']}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: widget.data['type'] == 'Expense'
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
                                "${widget.data['remainingAmount']}",
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
