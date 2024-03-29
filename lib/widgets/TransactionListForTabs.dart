import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/widgets/TransacctionList.dart';

class TranscationListForTab extends StatefulWidget {
  TranscationListForTab(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  final String category;
  final String type;
  final String monthYear;

  @override
  State<TranscationListForTab> createState() => _TranscationListForTabState();
}

class _TranscationListForTabState extends State<TranscationListForTab> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .where('monthyear', isEqualTo: widget.monthYear)
        .where('type', isEqualTo: widget.type);

    if (widget.category != 'All') {
      query = query.where('category', isEqualTo: widget.category);
    }
    return FutureBuilder<QuerySnapshot>(
      future: query.limit(150).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Transaction Found'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var cardData = data[index];
              return TransactionList(
                userId: userId,
                data: cardData,
              );
            });
      },
    );
  }
}
