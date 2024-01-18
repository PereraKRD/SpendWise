import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/common_widgets/IconItemRow.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/sign_up.dart';
import 'package:spendwise/widgets/profileuserdata.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  var isLogoutLoader = false;
  var authService = AuthService();

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

  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userID).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text('Document does not exist');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
            backgroundColor: TColor.white,
            appBar: AppBar(
              backgroundColor: TColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TColor.white),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(children: [
                  ProfileUserData(
                    userId: userID,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 8),
                          child: Text(
                            "Actions",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.1),
                            ),
                            color: TColor.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: IconItemRow(
                                  title: "Instructions To Reset(*)",
                                  icon: "assets/img/hbo_logo.png",
                                  value: "Click",
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Use ?? to provide a default value (false) if confirmReset is null
                                  bool confirmReset = (await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure you want to delete this transaction?'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: Text('Yes'),
                                              ),
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text('No'),
                                              ),
                                            ],
                                          );
                                        },
                                      )) ??
                                      false;

                                  // If the user confirmed, reset the values
                                  int budget = data['budget'];
                                  if (confirmReset) {
                                    int remainingAmount = budget;
                                    int totalExpenses = 0;
                                    int totalIncomes = 0;

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user?.uid)
                                        .update({
                                      'remainingAmount': remainingAmount,
                                      'totalExpenses': totalExpenses,
                                      'totalIncomes': totalIncomes,
                                      'updatedAt': timestamp,
                                    });
                                  }
                                },
                                child: IconItemRow(
                                  title: "Reset Summary",
                                  icon: "assets/img/chart.png",
                                  value: "Click",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  confirmSignOut(context);
                                },
                                child: IconItemRow(
                                  title: "Sign Out",
                                  icon: "assets/img/logout.png",
                                  value: "Click",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ));
      },
    );
  }
}
