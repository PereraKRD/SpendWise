import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/validators.dart';
import 'package:spendwise/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class editTransactionForm extends StatefulWidget {
  const editTransactionForm({super.key});

  @override
  State<editTransactionForm> createState() => _editTransactionFormState();
}

class _editTransactionFormState extends State<editTransactionForm> {
  var type = 'Expense';
  var category = 'Other';

  final _formkey = GlobalKey<FormState>();

  var isLoader = false;
  var authService = AuthService();
  var appValidator = AppValidators();
  var amountEditingController = TextEditingController();
  var titleEditingController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditingController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalExpenses = userDoc['totalExpenses'];
      int totalIncomes = userDoc['totalIncomes'];

      if (type == 'Income') {
        remainingAmount += amount;
        totalIncomes += amount;
      } else {
        remainingAmount -= amount;
        totalExpenses += amount;
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
      var data = {
        'id': id,
        'title': titleEditingController.text,
        'amount': amount,
        'type': type,
        'category': category,
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
          .doc(id)
          .set(data);

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
            TextFormField(
              controller: titleEditingController,
              validator: appValidator.emptyCheck,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: amountEditingController,
              validator: appValidator.emptyCheck,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(
              height: 10,
            ),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
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
