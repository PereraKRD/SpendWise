import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/Validators.dart';
import 'package:spendwise/widgets/CategoryDropdown.dart';
import 'package:uuid/uuid.dart';

class editTransactionForm extends StatefulWidget {
  const editTransactionForm({super.key, this.data, required this.userId});
  final dynamic data;
  final String userId;

  @override
  State<editTransactionForm> createState() => _editTransactionFormState();
}

class _editTransactionFormState extends State<editTransactionForm> {
  final _formkey = GlobalKey<FormState>();

  var isLoader = false;
  var authService = AuthService();
  var appValidator = AppValidators();
  late TextEditingController amountEditingController;
  late TextEditingController titleEditingController;
  late String type;
  late String category;

  var uid = Uuid();

  @override
  void initState() {
    super.initState();
    amountEditingController =
        TextEditingController(text: widget.data['amount'].toString());
    titleEditingController = TextEditingController(text: widget.data['title']);
    type = widget.data['type'];
    category = widget.data['category'];
  }

  Future<void> _submitEditTransactionForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditingController.text);
      DateTime date = DateTime.now();

      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // Retrieve existing transaction data
      final transactionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(widget.data['id'])
          .get();

      // Calculate the difference in amount for updating user statistics
      int oldAmount = transactionDoc['amount'];
      int newAmount = int.parse(amountEditingController.text.trim());
      int remainingAmount = userDoc['remainingAmount'];
      int totalExpenses = userDoc['totalExpenses'];
      int totalIncomes = userDoc['totalIncomes'];

      if (transactionDoc['type'] == 'Expense') {
        totalExpenses -= oldAmount;
        totalExpenses += newAmount;
        remainingAmount += oldAmount - newAmount;
      } else {
        totalIncomes -= oldAmount;
        totalIncomes += newAmount;
        remainingAmount = remainingAmount - oldAmount + newAmount;
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
