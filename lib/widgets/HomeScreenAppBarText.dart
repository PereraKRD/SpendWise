import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeCreenAppBarText extends StatefulWidget {
  const HomeCreenAppBarText({super.key, required this.userId});
  final String userId;

  @override
  State<HomeCreenAppBarText> createState() => _HomeCreenAppBarTextState();
}

class _HomeCreenAppBarTextState extends State<HomeCreenAppBarText> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots();
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

        return AppBarTextCard(
          data: data,
        );
      },
    );
  }
}

class AppBarTextCard extends StatefulWidget {
  const AppBarTextCard({
    super.key,
    required this.data,
  });
  final Map data;

  @override
  State<AppBarTextCard> createState() => _AppBarTextCardState();
}

class _AppBarTextCardState extends State<AppBarTextCard> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Hello ${widget.data['username']},",
      style: TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
