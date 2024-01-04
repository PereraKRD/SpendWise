import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
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

        return ProfileCard(
          data: data,
          userId: userId,
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.data,
    required this.userId,
  });
  final Map data;
  final String userId;

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController =
            TextEditingController(text: data['username']);
        TextEditingController phoneNumberController =
            TextEditingController(text: data['phone']);

        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateProfile(
                  usernameController.text.trim(),
                  phoneNumberController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

// Function to update the profile data
  void _updateProfile(String newUsername, String newPhoneNumber) {
    // Check if any of the fields are not empty before updating
    if (newUsername.isNotEmpty || newPhoneNumber.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': newUsername,
        'phone': newPhoneNumber,
      }).then((_) {
        // Handle successful update
      }).catchError((error) {
        // Handle error
        print('Failed to update profile: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/u1.png",
              width: 70,
              height: 70,
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data['username']}",
              style: TextStyle(
                  color: TColor.blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data['email']}",
              style: TextStyle(
                  color: TColor.primary.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            _showEditProfileDialog(context);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: TColor.border.withOpacity(0.15),
              ),
              color: TColor.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "Edit profile",
              style: TextStyle(
                  color: TColor.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
