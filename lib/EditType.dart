import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/validators.dart';
import 'package:uuid/uuid.dart';

class editTypeForm extends StatefulWidget {
  const editTypeForm({super.key, this.data, required this.userId});
  final dynamic data;
  final String userId;

  @override
  State<editTypeForm> createState() => _editTypeFormState();
}

class _editTypeFormState extends State<editTypeForm> {
  final _formkey = GlobalKey<FormState>();

  var isLoader = false;
  var authService = AuthService();
  var appValidator = AppValidators();
  late String type;

  var uid = Uuid();

  @override
  void initState() {
    super.initState();
    type = widget.data['type'];
  }

  Future<void> _submitEditTransactionForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DateTime date = DateTime.now();

      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // Retrieve existing transaction data
      final transactionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('transactions')
          .doc(widget.data['id'])
          .get();

      // Calculate the difference in amount for updating user statistics
      int Amount = transactionDoc['amount'];
      int remainingAmount = userDoc['remainingAmount'];
      int totalExpenses = userDoc['totalExpenses'];
      int totalIncomes = userDoc['totalIncomes'];

      if (transactionDoc['type'] == 'Expense') {
        totalExpenses = totalExpenses - Amount;
        totalIncomes = totalIncomes + Amount;
        remainingAmount = remainingAmount + Amount;
      } else {
        totalIncomes = totalIncomes - Amount;
        totalExpenses = totalExpenses + Amount;
        remainingAmount = remainingAmount - Amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'remainingAmount': remainingAmount,
        'totalExpenses': totalExpenses,
        'totalIncomes': totalIncomes,
        'updatedAt': timestamp,
      });

      // Update the transaction data in Firestore
      var updatedData = {
        'type': type,
        'monthyear': monthyear,
        'createdAt': timestamp,
        'totalExpenses': totalExpenses,
        'totalIncomes': totalIncomes,
        'remainingAmount': remainingAmount,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(widget.data['id'])
          .update(updatedData);

      Navigator.pop(context);
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(
              width: 5,
            ),
            DropdownButtonFormField(
              value: type,
              items: const [
                DropdownMenuItem(
                  value: 'Expense',
                  child: Text('Expense'),
                ),
                DropdownMenuItem(
                  value: 'Income',
                  child: Text('Income'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(TColor.secondary),
              ),
              onPressed: () {
                if (isLoader == false) {
                  _submitEditTransactionForm();
                  Navigator.pop(context);
                }
              },
              child: isLoader
                  ? Center(child: CircularProgressIndicator())
                  : Text('Edit Transaction',
                      style: TextStyle(color: TColor.primary)),
            )
          ],
        ),
      ),
    );
  }
}
