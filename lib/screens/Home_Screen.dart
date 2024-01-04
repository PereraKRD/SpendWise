import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/widgets/HeroCard.dart';
import 'package:spendwise/log_in.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/widgets/HomeScreenAppBarText.dart';
import 'package:spendwise/widgets/add_transaction.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoader = false;
  var authService = AuthService();

  confirmSignOut(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await performSignOut();
              },
              child: Text("Yes"),
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
        builder: ((context) => const LogInView()),
      ),
    );
    setState(() {
      isLogoutLoader = false;
    });
  }

  final userID = FirebaseAuth.instance.currentUser!.uid;

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
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.exit_to_app),
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
