import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/widgets/TransacctionList.dart';
import '../common/color_extension.dart';

class TransactionCard extends StatefulWidget {
  TransactionCard({super.key});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: TextStyle(
                  color: TColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "See all",
              style: TextStyle(
                  color: TColor.blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        RecentTransactions()
      ],
    );
  }
}

class RecentTransactions extends StatefulWidget {
  RecentTransactions({
    super.key,
  });

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots(),
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
                data: cardData,
                userId: userId,
              );
            });
      },
    );
  }
}
