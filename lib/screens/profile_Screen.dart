import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/common_widgets/IconItemRow.dart';
import 'package:spendwise/log_in.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/widgets/profileuserdata.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  bool isActive1 = false;
  bool isActive2 = false;

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
                Navigator.of(context).pop(); // Close the dialog
                await performSignOut(); // Close the dialog
                // Implement delete functionality here
              },
              child: Text('Yes'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
        builder: ((context) => const LogInView()),
      ),
    );
    setState(() {
      isLogoutLoader = false;
    });
  }

  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(children: [
              ProfileUserData(
                userId: userID,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        "General",
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
                          IconItemRow(
                            title: "Security",
                            icon: "assets/img/face_id.png",
                            value: "FaceID",
                          ),
                          IconItemSwitchRow(
                            title: "iCloud Sync",
                            icon: "assets/img/icloud.png",
                            value: isActive1,
                            didChange: (newVal) {
                              setState(() {
                                isActive1 = newVal;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "Analyse",
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
                          IconItemRow(
                            title: "Sorting",
                            icon: "assets/img/sorting.png",
                            value: "Date",
                          ),
                          IconItemRow(
                            title: "Summary",
                            icon: "assets/img/chart.png",
                            value: "Average",
                          ),
                          IconItemRow(
                            title: "Default currency",
                            icon: "assets/img/money.png",
                            value: "Rupees (Rs)",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "Appearance",
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
                          IconItemRow(
                            title: "App icon",
                            icon: "assets/img/app_icon.png",
                            value: "Default",
                          ),
                          IconItemSwitchRow(
                            title: "Dark Mode",
                            icon: "assets/img/light_theme.png",
                            value: isActive2,
                            didChange: (newVal) {
                              setState(() {
                                isActive2 = newVal;
                              });
                            },
                          ),
                          IconItemRow(
                            title: "Font",
                            icon: "assets/img/font.png",
                            value: "Inter",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        "Sign Out",
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
  }
}
