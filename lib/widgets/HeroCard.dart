import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/widgets/TransactionCard.dart';

class HeroCard extends StatefulWidget {
  HeroCard({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
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

        return Card(
          data: data,
        );
      },
    );
  }
}

class Card extends StatefulWidget {
  const Card({
    super.key,
    required this.data,
  });
  final Map data;

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),

          //Total Balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 239, 238, 254),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                const Text(
                  "Remaining Budget (Rs)",
                  style: TextStyle(
                      color: Color(0xff958BCE),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.data['remainingAmount']}",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            children: [
              CardOne(
                amount: "${widget.data['totalIncomes']}",
                heading: "Income",
                fontcolor: Color(0xff02C487),
              ),
              const SizedBox(
                width: 15,
              ),
              CardOne(
                amount: "${widget.data['totalExpenses']}",
                heading: "Expense",
                fontcolor: Color(0xffFC6158),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          TransactionCard(),
        ],
      ),
    );
  }
}

class CardOne extends StatefulWidget {
  CardOne({
    super.key,
    required this.fontcolor,
    required this.heading,
    required this.amount,
  });
  final Color fontcolor;
  final String heading;
  final String amount;

  @override
  State<CardOne> createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: widget.fontcolor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.heading}(Rs)",
                  style: TextStyle(
                      color: Color(0xff958BCE),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Icon(
                  widget.heading == "Income"
                      ? Icons.arrow_drop_up_outlined
                      : Icons.arrow_drop_down_outlined,
                  color: widget.fontcolor.withOpacity(0.5),
                  size: 30,
                )
              ],
            ),
            Text(
              "${widget.amount}",
              style: TextStyle(
                  color: widget.fontcolor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
