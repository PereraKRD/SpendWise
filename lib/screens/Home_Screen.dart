import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/sign_up.dart';
import 'package:spendwise/widgets/HeroCard.dart';
import 'package:spendwise/widgets/HomeScreenAppBarText.dart';
import 'package:spendwise/widgets/add_transaction.dart';

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

  confirmSignOut(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.of(context).pop();
                await performSignOut();
              },
              child: Text('Yes'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  performSignOut() async {
    setState(() {
      isLogoutLoader = true;
    });
    await authService.signOutUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const SignUpView()),
      ),
    );
    setState(() {
      isLogoutLoader = false;
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                confirmSignOut(context);
              },
              icon: isLogoutLoader
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.power_settings_new,
                      color: TColor.white,
                      size: 30,
                    ),
            ),
          ),
        ],
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
