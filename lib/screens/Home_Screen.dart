import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/SignUp.dart';
import 'package:spendwise/widgets/HeroCard.dart';
import 'package:spendwise/widgets/HomeScreenAppBarText.dart';
import 'package:spendwise/widgets/AddTransaction.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  bool isLogoutLoader = false;
  var authService = AuthService();

  _dialoBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Add Transaction",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            content: AddTransactionForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          _dialoBuilder(context);
        }),
        child: Icon(
          Icons.add,
          color: TColor.primary,
        ),
        backgroundColor: TColor.secondary,
      ),
      appBar: AppBar(
        backgroundColor: TColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        title: Align(
            alignment: Alignment.bottomLeft,
            child: HomeCreenAppBarText(
              userId: userID,
            )),
      ),
      backgroundColor: TColor.bg,
      body: SingleChildScrollView(
        child: HeroCard(
          userId: userID,
        ),
      ),
    );
  }
}
